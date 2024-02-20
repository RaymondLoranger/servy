defmodule Servy.TrackerTest do
  use ExUnit.Case, async: true

  alias Servy.Tracker

  doctest Tracker

  describe "Tracker.get_location/1" do
    test "returns an example wildthing location" do
      assert Tracker.get_location("roscoe") == %{
               lat: "44.4280 N",
               lng: "110.5885 W"
             }

      assert Tracker.get_location("smokey") == %{
               lat: "48.7596 N",
               lng: "113.7870 W"
             }
    end
  end
end
