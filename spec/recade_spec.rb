require 'recade'
require 'spec_helper'

# main module
module Recade
  RSpec.describe VERSION do
    it 'has a version number' do
      expect(Recade::VERSION).not_to be nil
    end
  end

  RSpec.describe Record do
    let(:base_file) { File.join(File.dirname(__FILE__), 'fixtures', 'test_record_default_records.yml') }
    let(:empty_file) { File.join(File.dirname(__FILE__), 'fixtures', 'test_record_empty_records.yml') }
    let(:deleted_file) { File.join(File.dirname(__FILE__), 'fixtures', 'test_record_deleted_records.yml') }
    let(:inserted_file) { File.join(File.dirname(__FILE__), 'fixtures', 'test_record_inserted_records.yml') }
    let(:updated_file) { File.join(File.dirname(__FILE__), 'fixtures', 'test_record_updated_records.yml') }

    def dump_result_sync(filename)
      new_records = YAML.load_file(filename)
      Record::Runner.sync(ENV['SPEC_TOOLS_HOST'], new_records)
      Record::Runner.dump(ENV['SPEC_TOOLS_HOST'])
    end

    def init_with(filename)
      Record::Runner.truncate(ENV['SPEC_TOOLS_HOST'])
      dump_result_sync(filename)
    end

    context 'when table is empty' do
      it 'inserts all record' do
        Record::Runner.truncate(ENV['SPEC_TOOLS_HOST'])
        expect(dump_result_sync(base_file)).to eq init_with(base_file)
      end
    end

    context 'when table is not empty' do
      it 'does be not change' do
        base = init_with(base_file)
        expect(dump_result_sync(base_file)).to eq base
      end

      it 'inserts record' do
        base = init_with(base_file)
        ins = Record::Formatter.fit_template(YAML.load_file(inserted_file)[6])
        ins['id'] = base.length + 1
        base.push(ins)
        expect(dump_result_sync(inserted_file)).to eq base
      end

      it 'deletes records' do
        base = init_with(base_file)
        base.delete_at(3)
        expect(dump_result_sync(deleted_file)).to eq base
      end

      it 'updated records' do
        base = init_with(base_file)
        upd = Record::Formatter.fit_template(YAML.load_file(updated_file)[4])
        upd.keys.each do |key|
          base[4][key] = upd[key]
        end
        expect(dump_result_sync(updated_file)).to eq base
      end
    end
  end
end
