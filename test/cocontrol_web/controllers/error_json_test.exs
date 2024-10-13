defmodule CocontrolWeb.ErrorJSONTest do
  use CocontrolWeb.ConnCase, async: true

  test "renders 404" do
    assert CocontrolWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert CocontrolWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
