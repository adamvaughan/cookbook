defmodule Cookbook.Plans.PlanTest do
  use Cookbook.DataCase

  alias Cookbook.Plans.Plan

  describe "changeset/2" do
    test "building a changeset" do
      changeset =
        Plan.changeset(%Plan{}, %{
          month: 3,
          year: 2019
        })

      assert changeset.valid?
      assert {:ok, plan} = Repo.insert(changeset)
      assert plan.month == 3
      assert plan.year == 2019
    end

    test "requires a month" do
      changeset =
        Plan.changeset(%Plan{}, %{
          year: 2019
        })

      refute changeset.valid?
      assert %{month: ["can't be blank"]} == errors_on(changeset)
    end

    test "requires a year" do
      changeset =
        Plan.changeset(%Plan{}, %{
          month: 3
        })

      refute changeset.valid?
      assert %{year: ["can't be blank"]} == errors_on(changeset)
    end

    test "requires a unique month/year" do
      insert(:plan, month: 3, year: 2019)

      changeset =
        Plan.changeset(%Plan{}, %{
          month: 3,
          year: 2019
        })

      assert changeset.valid?
      assert {:error, changeset} = Repo.insert(changeset)
      refute changeset.valid?
      assert %{month: ["has already been taken"]} == errors_on(changeset)
    end
  end
end
