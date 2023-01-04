defmodule NemoHelper.TimeUtil do
  def kst_now() do
    NaiveDateTime.utc_now() |> NaiveDateTime.add(9, :hour)
  end

  def iso_now() do
    kst_now() |> NaiveDateTime.to_string()
  end
end
