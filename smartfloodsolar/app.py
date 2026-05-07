import mysql.connector
from flask import Flask, render_template, request
import joblib
import requests
import pandas as pd
from collections import Counter

app = Flask(__name__)

# Flood model
flood_model = joblib.load("model/flood_model.pkl")
label_encoder = joblib.load("model/label_encoder.pkl")

# Solar model
solar_model = joblib.load("model/solar_model.pkl")
flood_encoder = joblib.load("model/flood_encoder.pkl")
damage_encoder = joblib.load("model/damage_encoder.pkl")

#database connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="QqWwEeRrTt@0818",
    database="smartflood"
)

cursor = db.cursor()

#API KEY
API_KEY = "1f1c92ff2133112af6841a46c4f9da29"

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/weather")
def weather():

    lat = request.args.get("lat")
    lon = request.args.get("lon")

    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?lat={lat}&lon={lon}&appid={API_KEY}&units=metric"
    )

    response = requests.get(url).json()

    data = {
        "temperature": response["main"]["temp"],
        "humidity": response["main"]["humidity"],
        "cloud_cover": response["clouds"]["all"]
    }

    return data

@app.route("/history")
def history():

    cursor.execute("""
        SELECT created_at, flood_risk, solar_risk,
               efficiency, latitude, longitude
        FROM predictions
        ORDER BY created_at DESC
    """)

    records = cursor.fetchall()

    return render_template("history.html", records=records)

@app.route("/markers")
def markers():

    cursor.execute("""
        SELECT latitude, longitude,
               flood_risk, solar_risk,
               efficiency, created_at
        FROM predictions
        WHERE latitude IS NOT NULL
          AND longitude IS NOT NULL
    """)

    rows = cursor.fetchall()

    data = []

    for row in rows:
        data.append({
            "lat": row[0],
            "lng": row[1],
            "flood_risk": row[2],
            "solar_risk": row[3],
            "efficiency": row[4],
            "date": str(row[5])
        })

    return data

@app.route("/dashboard")
def dashboard():

    query = """
    SELECT rainfall, flood_risk, solar_risk,
           efficiency, created_at,
           latitude, longitude
    FROM predictions
    """

    df = pd.read_sql(query, db)

    # KPI
    total_predictions = len(df)
    high_alerts = len(df[df["flood_risk"] == "High"])
    avg_efficiency = round(df["efficiency"].mean(), 2)

    most_common_risk = df["flood_risk"].mode()[0]

    # Flood chart
    flood_counts = df["flood_risk"].value_counts().to_dict()

    # Solar chart
    solar_counts = df["solar_risk"].value_counts().to_dict()

    # Rain trend
    rain_dates = df["created_at"].astype(str).tolist()
    rain_values = df["rainfall"].tolist()

    # Efficiency trend
    eff_values = df["efficiency"].tolist()

    # Mini map
    locations = df[
        ["latitude", "longitude", "flood_risk"]
    ].dropna().to_dict("records")

    return render_template(
        "dashboard.html",
        total_predictions=total_predictions,
        high_alerts=high_alerts,
        avg_efficiency=avg_efficiency,
        most_common_risk=most_common_risk,
        flood_counts=flood_counts,
        solar_counts=solar_counts,
        rain_dates=rain_dates,
        rain_values=rain_values,
        eff_values=eff_values,
        locations=locations
    )

@app.route("/predict", methods=["POST"])
def predict():

    # Get form values
    rainfall = float(request.form["rainfall"])
    temperature = float(request.form["temperature"])
    humidity = float(request.form["humidity"])
    water_level = float(request.form["water_level"])
    soil_moisture = float(request.form["soil_moisture"])
    cloud_cover = float(request.form["cloud_cover"])
    waterlogging = float(request.form["waterlogging"])
    latitude = float(request.form["latitude"])
    longitude = float(request.form["longitude"])

    # -------- Flood Prediction --------
    flood_input = [[
        rainfall,
        temperature,
        humidity,
        water_level,
        soil_moisture
    ]]

    flood_pred = flood_model.predict(flood_input)
    flood_risk = label_encoder.inverse_transform(flood_pred)[0]

    # -------- Solar Prediction --------
    encoded_flood = flood_encoder.transform([flood_risk])[0]

    solar_input = [[
        encoded_flood,
        cloud_cover,
        humidity,
        waterlogging
    ]]

    solar_pred = solar_model.predict(solar_input)
    solar_risk = damage_encoder.inverse_transform(solar_pred)[0]

    # -------- Efficiency --------
    if solar_risk == "Low":
        efficiency = 90
    elif solar_risk == "Medium":
        efficiency = 65
    else:
        efficiency = 35

    sql = """
    INSERT INTO predictions
    (rainfall, temperature, humidity, water_level,
    soil_moisture, cloud_cover, waterlogging,
    flood_risk, solar_risk, efficiency, latitude, longitude)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """

    values = (
        rainfall,
        temperature,
        humidity,
        water_level,
        soil_moisture,
        cloud_cover,
        waterlogging,
        flood_risk,
        solar_risk,
        efficiency,
        latitude,
        longitude
    )

    cursor.execute(sql, values)
    db.commit()    

    return render_template(
        "index.html",
        flood_risk=flood_risk,
        solar_risk=solar_risk,
        efficiency=efficiency
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
