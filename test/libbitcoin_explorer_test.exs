defmodule LibbitcoinExplorerTest do
  use ExUnit.Case
  doctest Libbitcoin.Explorer
  alias Libbitcoin.Explorer, as: E

  @address_decoded %{"wrapper" => %{"checksum" => "2876689768", "payload" => "b77f8b01ec4d27f6694328b86bb18b896a06acd5", "version" => "0"}}
  @address_embed "mwuvznCbGir5fvzMetPTqqeh3LYboQ4YgR"
  @address_ripe160 Base.decode16! "b77f8b01ec4d27f6694328b86bb18b896a06acd5", case: :lower
  @address_ripe160_base58 "5t3dBwh5vCTppJiQmLf7ytrTJCJ4CnZ7DnuoNjw4SA2aCRtvyisgMvC"
  @address_invalid "1XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

  @base58 "921icEfDXP4RLR5NJXoMTty9ibvbrTEDutwnv1N71zQm"
  @base58_str Base.decode16! "771fe3299c76585df12b3cce5bee8162b602c17c8f4048bf772a197cf3ca6866", case: :lower
  @base58check_encoded "2RYjHc645kejvd6L8hqqFwfJnTEaL1ubtLL3nQ6sRvo1NcJB3js"
  @base58check_decoded %{"wrapper" => %{"checksum" => "3190778536", "payload" => "771fe3299c76585df12b3cce5bee8162b602c17c8f4048bf772a197cf3ca6866", "version" => "42"}}

  @seed_bitcoin160 Base.decode16! "b92ec2269b519884f82a4a1e5f9bd005cfd83c7b", case: :lower
  @seed_bitcoin256 Base.decode16! "6b49530acaa0421e9e90e89e378bb9ef76d6ba5a6356b6b5826e3fc1f127c33d", case: :lower

  @hd_seed Base.decode16!("93e7adf05881784bddfc2f32269e774223aa53ad", case: :lower)
  @hd_priv_m "xprv9s21ZrQH143K3tWC4MDVv9EgeB631P7SoLvHXA6jnYhVazDWdk3Q7C9jtgF5Wbw2sYfrSUY5fRzGdVdsRR1hCJnug7rgGVRZnGi2DFxmw9n"
  @hd_priv_m_1 "xprv9vFNbzZNvhFziboBbCoPYH35yrCPm8aJ1HKvg9eonRZa8Tepq6kJRbPhzfmKKtQy122vnMDq7M2iKANQ12vyQXiRL3k6jjoSCuh1qsRe9Bx"
  @hd_priv_m_1h "xprv9vFNbzZXGMnxte8hERuyhjzJbX2BxLbVSiNEUC9Gxn1YSx1V4VJNM1yHGbRHytHZMJ7bUWpk8BE1uxa6AbEFpSL5bT6NHZzY6D6fgTtsfSi"
  @hd_pub_m "xpub661MyMwAqRbcGNafANkWHHBRCCvXQqqJAZqtKYWMLtEUTnYfBHMeezUDjy9SvR477Rvxqu81McqUfq2ruiyrTgeFs34vvBS2TMvZX4RKFLJ"
  @hd_pub_m_1 "xpub69Ej1W6Gm4pHw5sehELPuQypXt2tAbJ9NWFXUY4RLm6Z1FyyNe4YyPiBqwFpDnxNtXFKRrmju77pKNWVgz6Ahh3e4RZvauWskRryegYuHL5"
  @hd_pub_m_1h "xpub69Ej1W6R6jMG78DALTSz4sw39YrgMoKLowHqGaYtX7YXKkLdc2cctpHm7qHRo8Leb5D3yTyEy4w96qcZVJHjwGRMjUsBSj6W6ZBtqwCjfaf"
  @hd_addr_m "1HjFSwyWZrdwTXowHMHVc9E1uAHj2cSkvd"
  @hd_ec_priv_m Base.decode16!("c08949a206ea02d2ebaea635c205eb66d4171e68d6a6bb3e07cab9a7399855c1", case: :lower)
  @hd_ec_pub_m Base.decode16!("03b721e90b0edbd59d47ced1db31173921927d7811aaf01913b94651f952dc08c3", case: :lower)
  @hd_wif_m "L3fyaMgRnUfuUTvrF959yHCHb7ws1sQTYKt3GUvmYJDv3i8UjYLB"

  @tx_raw Base.decode16!("0100000001d35ebed0b7c9afe90aa73d52ee2fe70a6dc8bfd0640393ad4ac79d035031dec101000000db00483045022100fb82289c4d28c7838359fe711007b79fce8e104638f1002c15805f63a972a023022052067c1868e812162129f51add6b2df31b1aef234037a32ad6d498d7a452644201483045022100da9dd7da5cf7fad055636a3bea070771537214a66ccd797c6a94615b253b1f29022021f15a34aecfaf86005fc8f467b3c50211ce1f4a243ba76399e17160550706da0147522102ca57a3fac905b17eb04a94f91c4a397cb3ae49c22a2fbb20e4adc68126b1e2642103d6d3ef7212d64db15f5554f16ba1dcee993fab394ea9b1370e0a612374fbf8be52aeffffffff02a08601000000000017a91462dddcc7f141801324b02eac5f2dfb4c2fbb723487c04504000000000017a9142606041fb58c3e1f37d2920304b3587ba09079868700000000", case: :lower)
  @tx_decoded %{"transaction" => %{"hash" => "10dae1fd266649cb352c69f2e0887451d11f83cb08bd611874c4f5941d66511c",
                "inputs" => %{"input" => %{"address" => "38fWtwdVQwkrYuCsks3KqQ2Tm3i4rvomEX", "previous_output" => %{"hash" => "c1de3150039dc74aad930364d0bfc86d0ae72fee523da70ae9afc9b7d0be5ed3", "index" => "1"},
                    "script" => "zero [ 3045022100fb82289c4d28c7838359fe711007b79fce8e104638f1002c15805f63a972a023022052067c1868e812162129f51add6b2df31b1aef234037a32ad6d498d7a452644201 ] [ 3045022100da9dd7da5cf7fad055636a3bea070771537214a66ccd797c6a94615b253b1f29022021f15a34aecfaf86005fc8f467b3c50211ce1f4a243ba76399e17160550706da01 ] [ 522102ca57a3fac905b17eb04a94f91c4a397cb3ae49c22a2fbb20e4adc68126b1e2642103d6d3ef7212d64db15f5554f16ba1dcee993fab394ea9b1370e0a612374fbf8be52ae ]",
                    "sequence" => "4294967295"}}, "lock_time" => "0",
                "outputs" => %{"output" => %{"address" => "35A4oqfcPkVxodAQ2oWhExchQuqHVfZe5w", "script" => "hash160 [ 2606041fb58c3e1f37d2920304b3587ba0907986 ] equal", "value" => "280000"}}, "version" => "1"}}

  test "address-decode" do
    assert {:ok, @address_decoded} = E.address_decode(@hd_addr_m)
  end

  test "address-embed" do
    assert {:ok, @address_embed} = E.address_embed(@hd_addr_m, 111)
  end

  test "address-encode" do
    assert {:ok, @hd_addr_m} = E.address_encode(@address_ripe160, 0)
  end

  test "address-validate" do
    assert {:ok, :valid} = E.address_validate(@hd_addr_m)
    assert {:error, :invalid} = E.address_validate(@address_invalid)
  end

  test "base58-encode" do
    assert {:ok, @base58} = E.base58_encode(@base58_str)
  end

  test "base58-decode" do
    assert {:ok, @base58_str} = E.base58_decode(@base58)
  end

  test "base58check-encode" do
    assert {:ok, @base58check_encoded} = E.base58check_encode(@base58_str, 42)
  end

  test "base58check-decode" do
    assert {:ok, @base58check_decoded} = E.base58check_decode(@base58check_encoded)
  end

  test "bitcoin160" do
    assert {:ok, @seed_bitcoin160} = E.bitcoin160(@hd_seed)
  end
  
  test "bitcoin256" do
    assert {:ok, @seed_bitcoin256} = E.bitcoin256(@hd_seed)
  end

  test "btc-to-satoshi" do
    assert {:ok, 100_000_000} = E.btc_to_satoshi(1)
    assert {:ok, 110_000_000} = E.btc_to_satoshi(1.1)
    assert {:ok, 100_000_000} = E.btc_to_satoshi("1")
    assert {:ok, 110_000_000} = E.btc_to_satoshi("1.1")
  end

  test "hd-new" do
    assert {:ok, @hd_priv_m} ==  E.hd_new(@hd_seed)
  end

  test "hd-private" do
    assert {:ok, @hd_priv_m_1} ==  E.hd_private(@hd_priv_m, 1)
  end

  test "hd-private hard" do
    assert {:ok, @hd_priv_m_1h} ==  E.hd_private(@hd_priv_m, 1, true)
  end

  test "hd-public from xpriv" do
    assert {:ok, @hd_pub_m_1} ==  E.hd_public(@hd_priv_m, 1)
  end

  test "hd-public hard xpriv" do
    assert {:ok, @hd_pub_m_1h} ==  E.hd_public(@hd_priv_m, 1, true)
  end

  test "hd-public from xpub" do
    assert {:ok, @hd_pub_m_1} ==  E.hd_public(@hd_pub_m, 1)
  end

  test "hd-public hard xpub" do
    assert {:error, "The hard option requires a private key."} ==  E.hd_public(@hd_pub_m, 1, true)
  end

  test "hd-to-address" do
    assert {:ok, @hd_addr_m} == E.hd_to_address(@hd_priv_m)
    assert {:ok, @hd_addr_m} == E.hd_to_address(@hd_pub_m)
  end

  test "hd-to-ec" do
    assert {:ok, @hd_ec_priv_m} == E.hd_to_ec(@hd_priv_m)
    assert {:ok, @hd_ec_pub_m} == E.hd_to_ec(@hd_pub_m)
  end

  test "hd-to-public" do
    assert {:ok, @hd_pub_m} == E.hd_to_public(@hd_priv_m)
  end

  test "hd-to-wif" do
    assert {:ok, @hd_wif_m} == E.hd_to_wif(@hd_priv_m)
  end

  test "tx_decode" do
    assert {:ok, @tx_decoded} == E.tx_decode(@tx_raw)
  end

end
