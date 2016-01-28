module Any2Tmx
  class PhraseSet
    attr_reader :traversable, :locale

    def initialize(traversable, locale)
      @traversable = traversable
      @locale = locale
    end

    def zip(other_set, &block)
      traversable.zip(other_set.traversable, &block)
    end
  end
end
