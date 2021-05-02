defmodule TechstackNews.NewsTest do
  use TechstackNews.DataCase

  alias TechstackNews.News

  describe "items" do
    alias TechstackNews.News.Item

    @valid_attrs %{published_at: ~D[2010-04-17], title: "some title", url: "some url"}
    @update_attrs %{
      published_at: ~D[2011-05-18],
      title: "some updated title",
      url: "some updated url"
    }
    @invalid_attrs %{published_at: nil, title: nil, url: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> News.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert News.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert News.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = News.create_item(@valid_attrs)
      assert item.published_at == ~D[2010-04-17]
      assert item.title == "some title"
      assert item.url == "some url"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = News.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = News.update_item(item, @update_attrs)
      assert item.published_at == ~D[2011-05-18]
      assert item.title == "some updated title"
      assert item.url == "some updated url"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = News.update_item(item, @invalid_attrs)
      assert item == News.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = News.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> News.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = News.change_item(item)
    end
  end

  describe "locations" do
    alias TechstackNews.News.Location

    @valid_attrs %{domain: "some domain"}
    @update_attrs %{domain: "some updated domain"}
    @invalid_attrs %{domain: nil}

    def location_fixture(attrs \\ %{}) do
      {:ok, location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> News.create_location()

      location
    end

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert News.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert News.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      assert {:ok, %Location{} = location} = News.create_location(@valid_attrs)
      assert location.domain == "some domain"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = News.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      assert {:ok, %Location{} = location} = News.update_location(location, @update_attrs)
      assert location.domain == "some updated domain"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = News.update_location(location, @invalid_attrs)
      assert location == News.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = News.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> News.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = News.change_location(location)
    end
  end
end
