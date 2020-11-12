require './spec/spec_helper'

describe Bingo::Strip do

  let(:test_strip) { {tickets:[
    [
      [9,nil,28,nil,46,nil],
      [nil,12,21,37,nil,54],
      [2,15,25,nil,nil,nil]
    ],
    [
      [nil,nil,nil,nil,43,nil],
      [nil,10,nil,35,nil,59],
      [nil,nil,nil,39,42,53]
    ],
    [
      [7,16,20,34,49,nil],
      [6,nil,27,nil,47,55],
      [5,nil,nil,nil,48,nil]
    ],
    [
      [nil,13,24,nil,45,57],
      [3,14,nil,32,nil,nil],
      [8,17,26,nil,nil,58]
    ],
    [
      [1,18,nil,33,40,50],
      [nil,nil,nil,31,44,56],
      [nil,nil,nil,38,nil,51]
    ],
    [
      [4,19,23,36,41,nil],
      [nil,nil,29,30,nil,nil],
      [nil,11,22,nil,nil,52]
    ]
  ]}}

  let(:test_game) {
    {_id:{"$oid":"5fad83c78a86f85eba6a5d4c"},game_id:98481,available_values:[8,57,27,58,51,38,33,26,32,37,2,13,11,54,21,34,12,10,30,39,19,9,25,24,18,16,20,46,47,4,28,7,3,56,41,52,53,15,6,31,29,1,45,59,44,55,14,42,48,40,35,23,49,50,22,17,36],taken_values:[5,43],scores:{blue:0,red:0}}
  }

  describe '.check' do
    describe 'first row' do
      let(:subject) { described_class.new(test_strip) }

      it 'should return one row' do
        expect(subject.check(test_game[:taken_values]).uniq).to eq([1])
      end
    end
  end
end
