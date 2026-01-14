defmodule MysqrftWeb.AshTypescriptRpcController do
  use MysqrftWeb, :controller

  def run(conn, params) do
    result = AshTypescript.Rpc.run_action(:mysqrft, conn, params)
    json(conn, result)
  end

  def validate(conn, params) do
    result = AshTypescript.Rpc.validate_action(:mysqrft, conn, params)
    json(conn, result)
  end
end
