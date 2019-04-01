defmodule Cookbook.Lists.ListTest do
  use Cookbook.DataCase

  alias Cookbook.Lists.List

  describe "changeset/2" do
    test "building a changeset" do
      plan = insert(:plan)

      changeset =
        List.changeset(%List{}, %{
          plan_id: plan.id,
          items: [
            %{
              quantity: 1,
              measurement: "cup",
              description: "rice"
            }
          ]
        })

      assert changeset.valid?
      assert {:ok, list} = Repo.insert(changeset)
      assert length(list.items) == 1
      assert Enum.at(list.items, 0).quantity == 1
      assert Enum.at(list.items, 0).measurement == "cup"
      assert Enum.at(list.items, 0).description == "rice"
      assert list.plan_id == plan.id
    end

    test "requires a plan" do
      changeset =
        List.changeset(%List{}, %{
          items: [
            %{
              quantity: 1,
              measurement: "cup",
              description: "rice"
            }
          ]
        })

      refute changeset.valid?
      assert %{plan_id: ["can't be blank"]} == errors_on(changeset)
    end
  end
end
