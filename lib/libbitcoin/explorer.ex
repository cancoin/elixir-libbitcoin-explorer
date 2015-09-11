defmodule Libbitcoin.Explorer do

  @port_opts [:stream, :binary, :eof, :stderr_to_stdout, :exit_status]

  @address_validate_valid_reply "The address is valid.\n"
  @address_validate_invalid_reply "The address is not valid.\n"

  def address_decode(address) do
    spawn_command("address-decode", [address], &json_reply(&1))
  end

  def address_embed(address, version) do
    spawn_command("address-embed", [address, "--version", version], &string_reply(&1))
  end

  def address_encode(ripe160, version) do
    spawn_command("address-encode", ["--ripe160", to_hex(ripe160), "--version", version], &string_reply(&1))
  end

  def address_validate(address) do
    spawn_command("address-validate", [address], &string_reply(&1))
  end

  def base58_encode(str) do
    spawn_command("base58-encode", [to_hex(str)], &string_reply(&1))
  end

  def base58_decode(str) do
    spawn_command("base58-decode", [str], &hex_reply(&1))
  end

  def base58check_encode(str, version) do
    spawn_command("base58check-encode", ['--base16', to_hex(str), '--version', version], &string_reply(&1))
  end

  def base58check_decode(str) do
    spawn_command("base58check-decode", [str], &json_reply(&1))
  end

  def bitcoin160(str) do
    spawn_command("bitcoin160", [to_hex(str)], &hex_reply(&1))
  end

  def bitcoin256(str) do
    spawn_command("bitcoin256", [to_hex(str)], &hex_reply(&1))
  end

  def btc_to_satoshi(btc) do
    spawn_command("btc-to-satoshi", [to_string(btc)], &integer_reply(&1))
  end

  def hd_new(seed) do
    spawn_command("hd-new", [to_hex(seed)], &string_reply(&1))
  end

  def hd_private(xpriv, index, hard \\ false) do
    argv = if hard do
      [xpriv, "--index", index, "--hard"]
    else
      [xpriv, "--index", index]
    end

    spawn_command("hd-private", argv, &string_reply(&1))
  end

  def hd_public(xkey, index, hard \\ false) do
    argv = if hard do
      [xkey, "--index", index, "--hard"]
    else
      [xkey, "--index", index]
    end

    spawn_command("hd-public", argv, &string_reply(&1))
  end

  def hd_to_address(xkey) do
    spawn_command("hd-to-address", [xkey], &string_reply(&1))
  end

  def hd_to_ec(xkey) do
    spawn_command("hd-to-ec", [xkey], &hex_reply(&1))
  end

  def hd_to_public(xkey) do
    spawn_command("hd-to-public", [xkey], &string_reply(&1))
  end

  def hd_to_wif(xkey) do
    spawn_command("hd-to-wif", [xkey], &string_reply(&1))
  end

  def tx_decode(tx) do
    spawn_command("tx-decode", [to_hex(tx)], &json_reply(&1))
  end

  def spawn_command(command, argv, formatter \\ fn(reply) -> reply end) do
    open_port(command, argv) |> await_reply(formatter)
  end

  def await_reply(port, formatter, buffer \\ <<>>, state \\ :ok) do
    receive do
      {^port, {:exit_status, 0}} ->
        await_reply(port, formatter, buffer)
      {^port, {:exit_status, _n}} ->
        await_reply(port, formatter, buffer, :error)
      {^port, {:data, data}} ->
        await_reply(port, formatter, buffer <> data)
      {^port, :eof} ->
        if state == :error do
          {:ok, error} = string_reply(buffer)
          {:error, error}
        else
          formatter.(buffer)
        end
    after
      2000 ->
        :timeout
    end
  end

  def open_port(command, argv) do
     Port.open({:spawn, format_command(command, argv)}, @port_opts)
  end

  def format_command(command, argv) do
    '/usr/local/bin/bx '
      ++ to_char_list(command)
      ++ ' --format=json '
      ++ (argv |> Enum.join(" ") |> to_char_list)
  end

  def string_reply(@address_validate_valid_reply) do
    {:ok, :valid}
  end
  def string_reply(@address_validate_invalid_reply) do
    {:ok, :invalid}
  end
  def string_reply(reply) do
    {:ok, String.strip(reply)}
  end

  def json_reply(reply) do
    JSX.decode(reply)
  end

  def hex_reply(reply) do
    {:ok, reply} = string_reply(reply)
    Base.decode16(reply, case: :lower)
  end

  def integer_reply(reply) do
    {integer, _rest} = Integer.parse(reply)
    {:ok, integer}
  end

  def to_hex(bin) do
    Base.encode16(bin, case: :lower)
  end

end
