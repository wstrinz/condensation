require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Condensation::Filters::DaysSince do
  def render_with_filter(template, context)
    template.render(context, filters: [Condensation::Filters::DaysSince])
  end

  let(:now) do
    Time.utc(2014, 5, 30, 0, 0, 0)
  end

  before do
    Timecop.freeze(now)
  end

  after do
    Timecop.return
  end

  it 'should handle UTC ISO 8601 dates' do
    created_at = '2014-05-15T10:00:00Z'
    template = Liquid::Template.parse('{{ created_at | days_since }}')
    result = render_with_filter(template, 'created_at' => created_at)
    result.must_equal '14'
  end

  it 'should handle non-UTC ISO 8601 dates' do
    created_at = '2014-05-15T20:00:00-07:00'
    template = Liquid::Template.parse('{{ created_at | days_since }}')
    result = render_with_filter(template, 'created_at' => created_at)
    result.must_equal '13'
  end

  it 'should handle Time input' do
    created_at = Time.utc(2014, 5, 20, 0, 0, 0)
    template = Liquid::Template.parse('{{ created_at | days_since }}')
    result = render_with_filter(template, 'created_at' => created_at)
    result.must_equal '10'
  end

  it 'should handle malformed dates' do
    created_at = 'foo'
    template = Liquid::Template.parse('{{ created_at | days_since }}')
    result = render_with_filter(template, 'created_at' => created_at)
    result.must_equal ''
  end

  it 'should be zero for days in the future' do
    created_at = '2014-06-01T20:00:00Z'
    template = Liquid::Template.parse('{{ created_at | days_since }}')
    result = render_with_filter(template, 'created_at' => created_at)
    result.must_equal '0'
  end

  it 'should handle empty string input' do
    created_at = ''
    template = Liquid::Template.parse('{{ created_at | days_since }}')
    result = render_with_filter(template, 'created_at' => created_at)
    result.must_equal ''
  end

  it 'should handle nil input' do
    created_at = nil
    template = Liquid::Template.parse('{{ created_at | days_since }}')
    result = render_with_filter(template, 'created_at' => created_at)
    result.must_equal ''
  end
end
