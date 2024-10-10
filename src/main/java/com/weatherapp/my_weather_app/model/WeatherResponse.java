package com.weatherapp.my_weather_app.model;

import java.util.List;

public class WeatherResponse {
	private String name;
	
	private Sys sys;
	
	private List<Weather> weather;
	private Main main;
	private Wind wind;
	private long dt;
	private int timezone;
	
	public int getTimezone() {
		return timezone;
	}

	public void setTimezone(int timezone) {
		this.timezone = timezone;
	}

	public long getDt() {
		return dt;
	}

	public void setDt(long dt) {
		this.dt = dt;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Sys getSys() {
		return sys;
	}

	public void setSys(Sys sys) {
		this.sys = sys;
	}

	public List<Weather> getWeather() {
		return weather;
	}

	public void setWeather(List<Weather> weather) {
		this.weather = weather;
	}

	public Main getMain() {
		return main;
	}

	public void setMain(Main main) {
		this.main = main;
	}

	public Wind getWind() {
		return wind;
	}

	public void setWind(Wind wind) {
		this.wind = wind;
	}

	public static class Sys{
		private String country;
		private long sunrise;
		private long sunset;

		public long getSunrise() {
			return sunrise;
		}

		public void setSunrise(long sunrise) {
			this.sunrise = sunrise;
		}

		public long getSunset() {
			return sunset;
		}

		public void setSunset(long sunset) {
			this.sunset = sunset;
		}

		public String getCountry() {
			return country;
		}

		public void setCountry(String country) {
			this.country = country;
		}
	}
	
	public static class Weather {
		private int id;
		private String description;
		private String icon;
		
		public String getIcon() {
			return icon;
		}
		public void setIcon(String icon) {
			this.icon = icon;
		}
		public int getId() {
			return id;
		}
		public void setId(int id) {
			this.id = id;
		}
		public String getDescription() {
			return description;
		}
		public void setDescription(String description) {
			this.description = description;
		}
	}
	
	public static class Main {
		private double temp;
		private int humidity;
		private double feels_like;
		private double temp_min;
		private double temp_max;
		
		public double getTemp_min() {
			return temp_min;
		}
		public void setTemp_min(double temp_min) {
			this.temp_min = temp_min;
		}
		public double getFeels_like() {
			return feels_like;
		}
		public void setFeels_like(double feels_like) {
			this.feels_like = feels_like;
		}
		public double getTemp_max() {
			return temp_max;
		}
		public void setTemp_max(double temp_max) {
			this.temp_max = temp_max;
		}
		
		public double getTemp() {
			return temp;
		}
		public void setTemp(double temp) {
			this.temp = temp;
		}
		public int getHumidity() {
			return humidity;
		}
		public void setHumidity(int humidity) {
			this.humidity = humidity;
		}
	}
	
	public static class Wind {
		private double speed;

		public double getSpeed() {
			return speed;
		}

		public void setSpeed(double speed) {
			this.speed = speed;
		}
	}
}
