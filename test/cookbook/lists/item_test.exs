defmodule Cookbook.Lists.ItemTest do
  use Cookbook.DataCase

  alias Cookbook.Lists.Item

  describe "changeset/2" do
    test "building a changeset" do
      list = insert(:list)

      changeset =
        Item.changeset(%Item{}, %{
          quantity: 1,
          measurement: "cup",
          description: "rice",
          list_id: list.id
        })

      assert changeset.valid?
      assert {:ok, item} = Repo.insert(changeset)
      assert item.quantity == 1
      assert item.measurement == "cup"
      assert item.description == "rice"
      assert item.list_id == list.id
      refute item.purchased
      refute item.manually_added
    end

    test "requires a description" do
      list = insert(:list)

      changeset =
        Item.changeset(%Item{}, %{
          quantity: 1,
          measurement: "cup",
          list_id: list.id
        })

      refute changeset.valid?
      assert %{description: ["can't be blank"]} == errors_on(changeset)
    end
  end
end
