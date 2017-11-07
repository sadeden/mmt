# frozen_string_literal: true

RSpec.shared_examples 'central reserve' do
  let(:event_store) { RailsEventStore::Client.new }
  let(:bitcoin) { create :coin, name: 'Bitcoin', code: 'BTC' }
  let(:neo) { create :coin, name: 'Antshares', code: 'NEO' }
  let(:publish_event) { ->(event_type, data, stream) { event_store.publish_event(event_type.new(data: data), stream_name: stream) } }

  before do
    allocate_btc = {
      coin_id: bitcoin.id,
      quantity: 160000000,
      subdivision: bitcoin.subdivision,
      rate: 1,
    }
    publish_event[ Events::Coin::Allocation, allocate_btc, bitcoin.stream_name ]

    allocate_neo = {
      coin_id: neo.id,
      quantity: 15251500000,
      subdivision: neo.subdivision,
      rate: 0.04247673,
    }
    publish_event[ Events::Coin::Allocation, allocate_neo, neo.stream_name ]

    allocate_to_member = {
      coin_id: neo.id,
      quantity: 6095831535,
      member_id: member.id,
      rate: '0.00366226',
    }
    publish_event[ Events::Member::Allocation, allocate_to_member, member.stream_name ]
  end

  it "allocates bitcoin" do
    expect(event_store).to have_published(an_event(Events::Coin::Allocation)).in_stream(bitcoin.stream_name)
    expect(bitcoin.central_reserve).to eq 160000000.to_d
  end

  it "allocates neo" do
    expect(event_store).to have_published(an_event(Events::Coin::Allocation)).in_stream(neo.stream_name)
    expect(neo.central_reserve).to eq 15251500000.to_d
  end

  it "credits member" do
    expect(event_store).to have_published(an_event(Events::Member::Allocation)).in_stream(member.stream_name)
    expect(member.coin_balance(neo.id)).to eq 6095831535.to_d
  end
end
