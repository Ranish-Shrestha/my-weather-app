package com.weatherapp.my_weather_app.controller;

import java.time.Instant;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.weatherapp.my_weather_app.model.WeatherResponse;

@Controller
public class WeatherController {
	@Value("${api.key}")
	private String apiKey;
	
	@GetMapping("/")
	public String getIndex() {
		return "index";
	}
	
	@GetMapping("/weather")
	public String getWeather(@RequestParam("city") String city, Model model) {
		// Create URL for OpenWeatherMap API request
		String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q="+ city +"&appid=" + apiKey;
		
		RestTemplate restTemplate = new RestTemplate();
		WeatherResponse weatherResponse = restTemplate.getForObject(apiUrl, WeatherResponse.class);
		
		if(weatherResponse != null) {
			// Date and Time
			long dt = weatherResponse.getDt();
			int timeZone = weatherResponse.getTimezone();

			long sunRise = weatherResponse.getSys().getSunrise();
			long sunSet = weatherResponse.getSys().getSunset();

			model.addAttribute("time", convertTime(dt, timeZone));
			model.addAttribute("sunRise", convertTime(sunRise, timeZone));
			model.addAttribute("sunSet", convertTime(sunSet, timeZone));
			
			model.addAttribute("city", weatherResponse.getName());
			model.addAttribute("country", weatherResponse.getSys().getCountry());
			model.addAttribute("weatherDescription", weatherResponse.getWeather().get(0).getDescription());
			
			model.addAttribute("temperature", (int)(weatherResponse.getMain().getTemp() - 273.15));
			model.addAttribute("feels_like", (int)(weatherResponse.getMain().getFeels_like() - 273.15));
			model.addAttribute("temp_max", (int)(weatherResponse.getMain().getTemp_max() - 273.15));
			model.addAttribute("temp_min", (int)(weatherResponse.getMain().getTemp_min() - 273.15));
			model.addAttribute("humidity", weatherResponse.getMain().getHumidity());
			
			model.addAttribute("windSpeed", weatherResponse.getWind().getSpeed());
			String icon = weatherResponse.getWeather().get(0).getIcon();
			int iconId = weatherResponse.getWeather().get(0).getId();
			String weatherIcon = ""; 
			//String weatherIcon = "wi wi-owm-" + weatherResponse.getWeather().get(0).getId();
			if(icon.contains("d")){
				weatherIcon = "wi wi-owm-day-" + iconId;
			} 
			else {
				weatherIcon = "wi wi-owm-night-" + iconId;
			}
			model.addAttribute("weatherIcon", weatherIcon);
			
		} else {
			model.addAttribute("error", "City not found!");
		}
		
		return "weather";
	}
	
	protected String convertTime(long dt, int timeZone) {
		
		ZoneId zoneId = ZoneId.ofOffset("UTC", ZoneOffset.ofTotalSeconds(timeZone));
		
		// Convert Unix time stamp to ZonedDateTime
        ZonedDateTime zonedateTime = Instant.ofEpochSecond(dt).atZone(zoneId);
        
        // Format the date and time
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm a");
        String dateTime = zonedateTime.format(formatter);
		
		return dateTime;
	}
	
}
