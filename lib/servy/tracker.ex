defmodule Servy.Tracker do
  @doc """
  Simulates sending a request to an external API
  to get the GPS coordinates of a wildthing.
  """

  @locations %{
    "roscoe" => %{lat: "44.4280 N", lng: "110.5885 W"},
    "smokey" => %{lat: "48.7596 N", lng: "113.7870 W"},
    "brutus" => %{lat: "43.7904 N", lng: "110.6818 W"},
    "bigfoot" => %{lat: "29.0469 N", lng: "98.8667 W"}
  }

  @wildthings Map.keys(@locations)

  @spec get_location(String.t()) :: map
  def get_location(wildthing) when wildthing in @wildthings do
    # CODE GOES HERE TO SEND A REQUEST TO THE EXTERNAL API

    # Sleep to simulate the API delay:
    Process.sleep(500)

    # Simulate response returned from the API:
    @locations[wildthing]
  end
end

# IO.ANSI.Plus.puts([
#   :islamic_green,
#   Servy.Tracker.get_location("roscoe") |> inspect()
# ])
