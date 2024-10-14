defmodule TryLuerl.API.Weather do
  use Lua.API, scope: "weather"

  deflua forecast(lat, long) do
    if not is_number(lat) or not is_number(long) do
      runtime_exception!("lat and long must be numbers")
    end

    query = %{latitude: lat, longitude: long, current: "temperature_2m,wind_speed_10m"}

    Req.get!("https://api.open-meteo.com/v1/forecast", params: query).body
  end
end
