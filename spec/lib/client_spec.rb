require 'spec_helper'

describe Audiosearch::Client do
  it "should initialize sanely" do
    client = get_client
  end

  it "should fetch root endpoint" do
    client = get_client
    resp = client.get('/')
    #puts pp( resp )
  end
end

describe "shows" do
  it "should fetch shows" do
    client = get_client

    show = client.get('/shows/74')
    #puts pp(coll)
    expect(show.title).to eq 'The World'

    # idiomatic
    show_i = client.get_show(74)
    expect(show.title).to eq (show_i.title)

  end
end

describe "episodes" do
  it "should fetch episodes" do
    client = get_client
    ep = client.get("/episodes/3431")
    ep_i = client.get_episode(3431)
    expect(ep.title).to eq(ep_i.title)
  end 

  it "should search" do
    client = get_client
    res = client.search({ q: 'test' })
    expect(res.is_success).to be_truthy
    expect(res.query).to eq 'test'
    expect(res.page).to eq 1
    expect(res.results.size).to eq 10
    res.results.each do |episode|
      printf("[%s] %s (%s)\n", episode.id, episode.title, episode.show_title)
      expect(episode.audio_files.size).to eq 1
    end
  end

  it "should search with filters" do
    client = get_client
    res = client.search({ q: 'test', filters: { network: 'npr' }, })
    #pp res
    expect(res.is_success).to be_truthy
    expect(res.query).to eq 'test'
    expect(res.total_results).to be >= 1
    res.results.each do |episode|
      printf("[%s] %s (%s)\n", episode.id, episode.title, episode.show_title)
      expect(episode.audio_files.size).to eq 1
      expect(episode.network).to eq 'NPR'
    end 
  end
end

describe "people" do

  it "should search people" do
    client = get_client
    res = client.search({ q: 'debbie' }, 'people')
    expect(res.is_success).to be_truthy
    res.results.each do |person|
      printf("[%s] %s %s\n", person.id, person.name, person.urls.self)
      expect(person.episodes.size).to be >= 1
      # fetch specific person
      p = client.get(person.urls.self).http_resp.body.first
      expect(person.name).to eq p.name
    end
  end

end

describe "tastemakers" do

  it "should fetch tastemakers" do
    client = get_client
    res = client.get('/tastemakers/episodes/5')
    #pp res
    expect(res.is_success).to be_truthy
    res.each do |episode|
      printf("[%s] %s (%s)\n", episode.episode.id, episode.episode.title, episode.episode.show_title)
      expect(episode.episode.audio_files.size).to eq 1
    end
  end

end

describe "trending" do

  it "should fetch trending" do
    client = get_client
    res = client.get('/trending')
    expect(res.is_success).to be_truthy
    res.each do |trend|
      printf("[%s] %s\n", trend.trend, trend.twitter_url)
      trend.related_episodes.each do |episode|
        printf("-> [%s] %s (%s)\n", episode.id, episode.title, episode.show_title)
        expect(episode.audio_files.size).to eq 1
      end
    end
  end

end

