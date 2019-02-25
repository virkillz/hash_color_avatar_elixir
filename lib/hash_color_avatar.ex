defmodule HashColorAvatar do
  @default_color :pastel
  @default_shape :circle
  @default_size 100
  @default_saturation 50
  @default_value 90

  use Bitwise

  @moduledoc """
  Documentation for HashColorAvatar.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HashColorAvatar.hello()
      :world

  """

  def hello do
    :world
  end

  defp get_rgb_color(color) do
    (color * 255 / 100) |> trunc()
  end

  def random_color(options \\ []) do
    seed = Enum.random(1..359)
    saturation = Keyword.get(options, :saturation, @default_saturation)
    value = Keyword.get(options, :value, @default_value)
    hsv_to_rgb(%{hue: seed, saturation: saturation, value: value}) |> rgb_to_hex
  end

  def set_color(hue_value, options \\ []) do
    saturation = Keyword.get(options, :saturation, @default_saturation)
    value = Keyword.get(options, :value, @default_value)
    hsv_to_rgb(%{hue: hue_value, saturation: saturation, value: value}) |> rgb_to_hex
  end

  def hsv_to_rgb(%{hue: hue, saturation: saturation, value: value} = _hsv) do
    h = hue / 60
    i = Float.floor(h) |> trunc()
    f = h - i

    sat_dec = saturation / 100

    p = value * (1 - sat_dec)
    q = value * (1 - sat_dec * f)
    t = value * (1 - sat_dec * (1 - f))

    p_rgb = get_rgb_color(p)
    v_rgb = get_rgb_color(value)
    t_rgb = get_rgb_color(t)
    q_rgb = get_rgb_color(q)

    case i do
      0 -> %{red: v_rgb, green: t_rgb, blue: p_rgb}
      1 -> %{red: q_rgb, green: v_rgb, blue: p_rgb}
      2 -> %{red: p_rgb, green: v_rgb, blue: t_rgb}
      3 -> %{red: p_rgb, green: q_rgb, blue: v_rgb}
      4 -> %{red: t_rgb, green: p_rgb, blue: v_rgb}
      _ -> %{red: v_rgb, green: p_rgb, blue: q_rgb}
    end
  end

  def rgb_to_hex(rgb) do
    hex =
      ((1 <<< 24) + (rgb.red <<< 16) + (rgb.green <<< 8) + rgb.blue)
      |> Integer.to_string(16)
      |> String.slice(1..1500)

    "#" <> hex
  end

  def gen_avatar(rawtext, options \\ []) do
    text = if rawtext == nil, do: "V K", else: rawtext

    color = Keyword.get(options, :color, @default_color)
    shape = Keyword.get(options, :shape, @default_shape)
    size = Keyword.get(options, :size, @default_size)

    fontsize = size / 2.4

    diameter = size / 2

    background_color =
      case color do
        "grey" -> "#c3c3c3"
        "black" -> "black"
        "pastel" -> random_color()
        nil -> text |> minihash |> set_color
        custom -> custom
      end

    case shape do
      "rect" ->
        '<svg width="#{size}" height="#{size}">
  <rect width="#{size}" height="#{size}" fill="#{background_color}" />
  <text fill="white" x="50%" y="65%" text-anchor="middle" style="font: bold #{fontsize}px sans-serif;" >#{
          get_initial(text)
        }</text>
  </circle>
   </svg>'

      _other ->
        '<svg width="#{size}" height="#{size}">
  <circle cx="#{diameter}" cy="#{diameter}" r="#{diameter}" stroke="white" stroke-width="4" fill="#{
          background_color
        }" />
  <text fill="white" x="50%" y="67%" text-anchor="middle" style="font: bold #{fontsize}px sans-serif;" >#{
          get_initial(text)
        }</text>
  </circle>
   </svg>'
    end
  end

  def get_initial(name) do
    clean_character =
      Regex.replace(~r/[\p{P}\p{S}\p{C}\p{N}]+/, name, "") |> String.trim() |> String.split()

    case Enum.count(clean_character) do
      0 ->
        "VK"

      1 ->
        clean_character |> List.first() |> String.at(0) |> String.upcase()

      other ->
        first = clean_character |> List.first() |> String.at(0) |> String.upcase()
        second = clean_character |> List.last() |> String.at(0) |> String.upcase()
        first <> second
    end
  end

  def minihash(string) do
    :crypto.hash(:md5, string)
    |> Base.encode16()
    |> String.slice(0..3)
    |> String.graphemes()
    |> string_to_int
    |> rem(359)
  end

  def string_to_int(list) do
    Enum.reduce(list, 1, fn x, acc ->
      case Integer.parse(x) do
        {0, _} -> 1 * acc
        {number, _} -> number * acc
        :error -> letter_to_integer(x) * acc
      end
    end)
  end

  def letter_to_integer(letter) do
    case letter do
      "A" -> 1
      "B" -> 2
      "C" -> 3
      "D" -> 4
      "E" -> 5
      "F" -> 6
      other -> 1
    end
  end
end
