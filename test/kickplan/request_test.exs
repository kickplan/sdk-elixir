defmodule Kickplan.RequestTest do
  use ExUnit.Case, async: true

  alias Kickplan.Request

  describe "build/1" do
    test "success: sets defaults" do
      assert %Request{
               body: nil,
               headers: [],
               method: :get,
               params: %{},
               path: "/",
               url: nil
             } = Request.build()
    end

    test "success: sets the request body" do
      body = %{foo: "bar"}
      assert %Request{body: ^body} = Request.build(body: body)
    end

    test "success: sets the request headers" do
      headers = [{"content-type", "application/json"}]
      assert %Request{headers: ^headers} = Request.build(headers: headers)
    end

    test "success: sets the request method" do
      assert %Request{method: :post} = Request.build(method: :post)
    end

    test "success: sets the request query params" do
      params = %{foo: "bar"}
      assert %Request{params: ^params} = Request.build(params: params)
    end

    test "success: sets the request path" do
      assert %Request{path: "/features"} = Request.build(path: "features")
      assert %Request{path: "/features"} = Request.build(path: "/features")
    end

    test "error: validates request headers are enumerable" do
      assert_raise ArgumentError, fn ->
        Request.build(headers: "invalid")
      end
    end

    test "error: validates request method" do
      assert_raise ArgumentError, fn ->
        Request.build(method: :invalid)
      end
    end

    test "error: validates request params are enumerable" do
      assert_raise ArgumentError, fn ->
        Request.build(params: "invalid")
      end
    end

    test "error: validates request path is a string" do
      assert_raise ArgumentError, fn ->
        Request.build(path: :invalid)
      end
    end
  end
end
