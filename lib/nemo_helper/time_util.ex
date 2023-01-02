defmodule NemoHelper.TimeUtil do
  def now() do
    :calendar.local_time() |> NaiveDateTime.from_erl!()
  end

  def iso_now() do
    now() |> NaiveDateTime.to_string()
  end
end
