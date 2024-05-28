defmodule Kickplan.SchemaTest do
  use ExUnit.Case, async: true

  defmodule TestSchema do
    use Kickplan.Schema

    defstruct name: nil, email: nil, age: 36
  end

  describe "from_json/1" do
    test "success: decodes and builds the schema" do
      data = %{"name" => "Jim", "age" => 40}

      assert %TestSchema{name: "Jim", age: 40, email: nil} = TestSchema.from_json(data)
    end

    test "success: retains defaults for missing fields" do
      data = %{"name" => "Jim"}

      assert %TestSchema{name: "Jim", age: 36} = TestSchema.from_json(data)
    end

    test "failure: returns default struct when data is invalid" do
      struct = %TestSchema{}

      assert ^struct = TestSchema.from_json("invalid")
    end
  end
end
