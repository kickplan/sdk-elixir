defmodule Kickplan.ResponseTest do
  use ExUnit.Case, async: true

  alias Kickplan.Response

  defmodule TestSchema do
    use Kickplan.Schema

    defstruct name: nil, age: 36
  end

  describe "into/2" do
    test "success: casts the response body into the provided schema" do
      data = %{"name" => "Jim", "age" => 40}
      resp = %Response{body: data}

      assert %TestSchema{name: "Jim", age: 40} = Response.into(resp, TestSchema)
    end

    test "success: casts all objects in a list of objects" do
      data = [
        %{"name" => "Jim", "age" => 40},
        %{"name" => "Jane"}
      ]

      resp = %Response{body: data}

      assert [
               %TestSchema{name: "Jim", age: 40},
               %TestSchema{name: "Jane", age: 36}
             ] = Response.into(resp, TestSchema)
    end
  end
end
