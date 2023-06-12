defmodule ColorfulPandas.Auth.AuthImplTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  import ColorfulPandas.Fixtures.Auth

  alias ColorfulPandas.Auth.Impl, as: Auth
  alias ColorfulPandas.Auth.Sessions
  alias ColorfulPandas.Auth.User

  setup do
    {session, user} = session_fixture()

    %{user: user, session: session}
  end

  describe "create_user/5" do
    test "returns a user" do
      provider = "google"
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      email = "google_user@example.com"
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      {:ok, result} = Auth.create_user(provider, uid, email, name, image_url)

      assert %User{} = result
    end

    test "returns a struct with the OAuth provider, UID, email, name, and image url" do
      provider = "google"
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      email = "google_user@example.com"
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      {:ok, result} = Auth.create_user(provider, uid, email, name, image_url)

      assert result.provider == provider
      assert result.uid == uid
      assert result.email == email
      assert result.name == name
      assert result.image_url == image_url
    end

    test "it returns an error when OAuth provider is nil" do
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      email = "google_user@example.com"
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      result = Auth.create_user(nil, uid, email, name, image_url)

      assert {:error, %Ecto.Changeset{} = changeset} = result
      assert errors_on(changeset).provider
    end

    test "it raises when UID is nil" do
      provider = "google"
      email = "google_user@example.com"
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      result = Auth.create_user(provider, nil, email, name, image_url)

      assert {:error, %Ecto.Changeset{} = changeset} = result
      assert errors_on(changeset).uid
    end

    test "it raises when email is nil" do
      provider = "google"
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      result = Auth.create_user(provider, uid, nil, name, image_url)

      assert {:error, %Ecto.Changeset{} = changeset} = result
      assert errors_on(changeset).email
    end

    test "it raises when name is nil" do
      provider = "google"
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      email = "google_user@example.com"
      image_url = "https://example.com/image.jpg"

      result = Auth.create_user(provider, uid, email, nil, image_url)

      assert {:error, %Ecto.Changeset{} = changeset} = result
      assert errors_on(changeset).name
    end
  end
end
