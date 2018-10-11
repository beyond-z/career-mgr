require 'resume_identifier'

require 'rails_helper'
require 'candidate_notifier'

RSpec.describe ResumeIdentifier do
  let(:json) { File.read("#{Rails.root}/spec/fixtures/portal_multiple_submissions_resume.json") }
  let(:resume_identifier) { ResumeIdentifier.new(json) }
  let(:preview_url) { 'http://example.com/preview' }
  
  describe '#attachments' do
    subject { resume_identifier.attachments }
    
    it { should be_an(Array) }
    it { should include({name: 'Bob_Smith.pdf', url: 'http://example.com/Bob_Smith.pdf'}) }
    it { should include({name: 'Bob-Smith-Cover-Letter.pdf', url: 'http://example.com/Bob-Smith-Cover-Letter.pdf'}) }
  end
  
  describe '#preview_url' do
    subject { resume_identifier.preview_url }
    it { should eq(preview_url) }
  end
  
  describe '#resume_url' do
    let(:url_right) { 'http://example.com/right.pdf' }
    let(:url_wrong) { 'http://example.com/wrong.pdf' }
    
    let(:attachments) do
      [
        {name: name_right, url: url_right},
        {name: name_wrong, url: url_wrong}
      ]
    end
    
    before { allow(resume_identifier).to receive(:attachments).and_return(attachments) }
    
    subject { resume_identifier.resume_url}
    
    describe 'when one attachment contains "resum"' do
      let(:name_right) { 'Bob-Resumé.pdf' }
      let(:name_wrong) { 'bob.pdf' }
      
      it { should eq(url_right) }
    end
    
    describe 'when one attachment contains "cover"' do
      let(:name_right) { 'Bob-Smith.pdf' }
      let(:name_wrong) { 'bob-cover-letter.pdf' }
      
      it { should eq(url_right) }
    end
    
    describe 'when neither attachment is a good option' do
      let(:name_right) { 'myrtles.pdf' }
      let(:name_wrong) { 'turtles.pdf' }
      
      it { should eq(preview_url) }
    end
  end
end
