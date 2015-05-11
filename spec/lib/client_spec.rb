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

  it "should fetch items" do
    client = get_client
    ep = client.get("/episodes/3431")
    ep_i = client.get_episode(3431)
    expect(ep.title).to eq(ep_i.title)
  end 

end

