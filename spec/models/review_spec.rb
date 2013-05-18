require 'spec_helper'

describe Review do
	it { should belong_to(:video) }
	it {validate_presence_of(:content)}
	it {validate_presence_of(:rating)}
end