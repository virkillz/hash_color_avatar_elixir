defmodule HashColorAvatarTest do
  use ExUnit.Case
  doctest HashColorAvatar

  test "generate initial empty" do
    assert HashColorAvatar.get_initial("") == "VK"
  end

  test "generate initial one name" do
    assert HashColorAvatar.get_initial("sandra") == "S"
  end

  test "generate initial two name" do
    assert HashColorAvatar.get_initial("guruh soekarno") == "GS"
  end

  test "generate initial three name" do
    assert HashColorAvatar.get_initial("guruh soekarno putra") == "GP"
  end

  test "test convert HSV to RGB" do
    assert HashColorAvatar.hsv_to_rgb(%{hue: 18, saturation: 50, value: 90}) == %{blue: 114, green: 149, red: 229}
  end

  test "test convert RGB to HEX" do
    assert HashColorAvatar.rgb_to_hex(%{red: 14, green: 13, blue: 12}) == "#0E0D0C"
  end

  test "test create avatar 2 name" do
    assert HashColorAvatar.gen_avatar("Marlyn Monroe") == '<svg width="100" height="100"><circle cx="50.0" cy="50.0" r="50.0" stroke="white" stroke-width="4" fill="pastel" /><text fill="white" x="50%" y="67%" text-anchor="middle" style="font: bold 41.66666666666667px sans-serif;" >MM</text></circle></svg>'
  end 

  test "test create avatar 5 name option rectangle" do
    assert HashColorAvatar.gen_avatar("Sagit Putri Lestari Harum Mewangi", [shape: "rect"]) == '<svg width="100" height="100"><rect width="100" height="100" fill="pastel" /><text fill="white" x="50%" y="65%" text-anchor="middle" style="font: bold 41.66666666666667px sans-serif;" >SM</text></circle></svg>'  
  end      

end
