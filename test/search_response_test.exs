defmodule Snap.SearchResponseTest do
  use ExUnit.Case

  alias Snap.SearchResponse

  test "new/1" do
    json =
      Path.join([__DIR__, "fixtures", "search_response.json"])
      |> File.read!()
      |> Jason.decode!()

    response = SearchResponse.new(json)
    assert response.took == 5
    assert response.timed_out == false
    assert response.shards == %{"total" => 5, "successful" => 5, "skipped" => 0, "failed" => 0}
    assert Enum.count(response) == 10

    assert response.hits.total == %{"value" => 10_000, "relation" => "gte"}
    assert response.hits.max_score == 1.0
    assert Enum.count(response.hits.hits) == 10

    hit = Enum.at(response.hits.hits, 0)
    assert hit.index == "dev-vacancies-v1-1610549150278184"
    assert hit.type == "_doc"
    assert hit.id == "adz-2553823"
    assert hit.score == 1.0
    assert hit.matched_queries == ["query_a"]
    assert hit.highlight == %{"message" => [" with the <em>number</em>", " <em>1</em>"]}

    assert hit.source == %{
             "adzuna_url" =>
               "https://www.adzuna.co.uk/jobs/details/1922923955?se=oMlhYylR6xGMhMp5avH9Cg&utm_medium=api&utm_source=0b5c6a90&v=1F37F0DE2CAA738178B918040AA403B42178B4A7",
             "contract_time" => "full_time",
             "contract_type" => "permanent",
             "description" =>
               "Science teacher required in Chelmsford September start MPS/UPS Are you a newly qualified Science teacher looking to kick-start your career? Are you an experienced Science teacher looking for the next step in your career? TLTP are currently working with a Secondary school based in Chelmsford that is seeking to appoint an enthusiastic Teacher of Science to join them in September. The school are graded 'Good' by Ofsted and currently have 1130 students in school. For the right candidate there would…",
             "employer_name" => "TLTP",
             "id" => "adz-2553823",
             "job_title" => "Science teacher",
             "location" => %{"lat" => 51.735802, "lon" => 0.469708},
             "timestamp" => "1610052006"
           }
  end
end
