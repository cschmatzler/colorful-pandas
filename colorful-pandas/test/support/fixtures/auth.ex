defmodule ColorfulPandas.Fixtures.Auth do
  @moduledoc false

  use Boundary, check: [in: false, out: false]

  alias ColorfulPandas.Auth.SignupFlow
  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Organization
  alias ColorfulPandas.Auth.Session
  alias ColorfulPandas.Repo

  def signup_flow_fixture(attrs) do
    default_attrs = %{
      provider: "google",
      uid: "1234",
      email: "user@example.com",
      name: "John Doe"
    }

    attrs = Map.merge(default_attrs, attrs)

    %SignupFlow{}
    |> SignupFlow.changeset(attrs)
    |> Repo.insert!()
  end

  def setup_identity(_context) do
    %{identity: identity_fixture()}
  end

  def setup_session(context) do
    identity = Map.get(context, :identity, identity_fixture())
    %{identity: identity, session: session_fixture(identity)}
  end

  def organization_fixture(attrs \\ %{}) do
    default_attrs = %{
      name: "Colorful Pandas"
    }

    attrs = Map.merge(default_attrs, attrs)

    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert!()
  end

  def identity_fixture(organization \\ organization_fixture(), attrs \\ %{}) do
    default_attrs = %{
      provider: "google",
      uid: make_ref() |> :erlang.ref_to_list() |> List.to_string(),
      email: "google_identity@example.com",
      name: "Google Identity",
      image: "https://example.com/image.jpg",
      organization_id: organization.id
    }

    attrs = Map.merge(default_attrs, attrs)

    %Identity{}
    |> Identity.changeset(attrs)
    |> Repo.insert!()
  end

  def session_fixture(identity \\ identity_fixture(), attrs \\ %{token: :crypto.strong_rand_bytes(Session.token_size())}) do
    token = Repo.insert!(%Session{token: attrs.token, identity_id: identity.id})

    token
  end
end
