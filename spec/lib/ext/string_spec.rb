require 'ext/string'

describe String do

  describe '#is_userid?' do
    it 'returns true for integer' do
      expect('12'.is_userid).to eq(true)
    end

    it 'returns false for non-integer' do
      expect('asdf'.is_userid).not_to eq(true)
    end
  end

  describe '#is_fn?' do
    it 'returns true for valid filename' do
      expect('asdf'.is_fn?).to be_truthy
    end

    it 'returns false for integer id' do
      expect('123'.is_fn?).to be_falsey
    end
  end

  describe '#is_true?' do
    context 'with true values' do
      specify { expect('y'.is_true?).to be_truthy    }
      specify { expect('Y'.is_true?).to be_truthy    }
      specify { expect('Yes'.is_true?).to be_truthy  }
      specify { expect('True'.is_true?).to be_truthy }
      specify { expect('true'.is_true?).to be_truthy }
      specify { expect('1'.is_true?).to be_truthy    }
    end

    context 'with non-true values' do
      specify { expect('n'.is_true?).to be_falsey     }
      specify { expect('0'.is_true?).to be_falsey     }
      specify { expect('false'.is_true?).to be_falsey }
      specify { expect('no'.is_true?).to be_falsey    }
    end
  end

  describe '#is_email_address?' do
    it 'returns true for valid addresses' do
      expect('andy@asdf.com'.is_email_address).to_not eq(false)
      expect('andy.smith@asdf.com'.is_email_address).to_not eq(false)
      expect('andy-smith@mail.asdf.com'.is_email_address).to_not eq(false)
    end

    it 'returns false for invalid address' do
      expect('@asdf'.is_email_address).not_to eq(true)
      expect('asdf'.is_email_address).not_to eq(true)
      expect('123'.is_email_address).not_to eq(true)
    end
  end

  describe '#is_username?' do
    it 'returns true for valid usernames' do
      expect('@asdf'.is_username).to_not eq(false)
      expect('asdf'.is_username).to_not eq(false)
      expect('1234'.is_username).not_to eq(true)
    end

    it 'returns false for invalid usernames' do
      expect('asdf@qwer.com'.is_username).to_not eq(true)
      expect('asdf#qwer'.is_username).to_not eq(true)
    end
  end

  describe '#identification_type' do
    it 'returns the proper ID type' do
      expect('1234'.identification_type).to          eq('userid')
      expect('asdf@qwer.com'.identification_type).to eq('email')
      expect('asdf'.identification_type).to          eq('username')
    end

    it 'returns nil for unknown types' do
      expect('asdf qwer'.identification_type).to be_nil
    end
  end

  describe '#username_normalize' do

    it 'makes no change to normal strings' do
      expect('asdf'.username_normalize).to eq('asdf')
    end

    it "strips leading '@'" do
      expect('@asdf'.username_normalize).to eq('asdf')
    end

  end

end
