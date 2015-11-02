require 'spec_helper'

module CMIS
  describe Utils do
    describe '#build_query_statement' do
      def qs(*args)
        CMIS::Utils.build_query_statement(*args)
      end

      it 'builds the correct query statement' do
        expect(qs('T', {})).to eq 'select * from T'
        expect(qs('T', foo: 'bar')).to eq "select * from T where foo = 'bar'"
        expect(qs('T', bar: 'baz', pif: 'poef')).to eq "select * from T where bar = 'baz' and pif = 'poef'"
        expect(qs('T', foo: { bar: 'baz', pif: 'poef' })).to eq "select * from T join foo as X on cmis:objectId = X.cmis:objectId where bar = 'baz' and pif = 'poef'"
        expect(qs('T', a: 'b', c: 'd', foo: { bar: 'baz', pif: 'poef' })).to eq "select * from T join foo as X on cmis:objectId = X.cmis:objectId where a = 'b' and c = 'd' and bar = 'baz' and pif = 'poef'"
      end
    end
  end
end
