require 'spec_helper'

describe "WeatherVane::HashComparer" do
  describe "when the target hash is missing a key from the source hash" do
    it "returns false" do
      target = {}
      source = {'a' => 1}
      
      WeatherVane::HashComparer.valid?(target, source).should be_false
    end
  end
  
  describe "when the target hash has the same top level keys as the source hash" do
    it "returns true" do
      target = {'a' => 1}
      source = {'a' => 1}
      
      WeatherVane::HashComparer.valid?(target, source).should be_true
    end
  end
  
  describe "when the target hash a key with a different value from the source hash" do
    it "returns true" do
      target = {'a' => 2}
      source = {'a' => 1}
      
      WeatherVane::HashComparer.valid?(target, source).should be_true
    end
  end
  
  describe "when the target hash has a key not in the source hash" do
    it "returns true" do
      target = {'a' => 2, 'b' => 3}
      source = {'a' => 1}
      
      WeatherVane::HashComparer.valid?(target, source).should be_true
    end
  end
  
  describe "when the target hash is missing a 2nd level key from the source hash" do
    it "returns false" do
      target = {'a' => {'c' => 4}}
      source = {'a' => {'b' => 2, 'c' => 3}}
      
      WeatherVane::HashComparer.valid?(target, source).should be_false
    end
  end
  
  describe "when the target hash has a 2nd level key not in the source hash" do
    it "returns true" do
      target = {'a' => {'b' => 2, 'c' => 3}}
      source = {'a' => {'c' => 4}}

      WeatherVane::HashComparer.valid?(target, source).should be_true
    end
  end
  
  describe "when the target hash is missing a 2nd level key from the source hash" do
    it "returns false" do
      target = {'a' => 1}
      source = {'a' => {'b' => 2, 'c' => 3}}

      WeatherVane::HashComparer.valid?(target, source).should be_false
    end
  end
  
  describe "when the target hash has another level when the source expects a value" do
    it "returns false" do
      target = {'a' => {'b' => 2, 'c' => 3}}
      source = {'a' => 1}
      
      WeatherVane::HashComparer.valid?(target, source).should be_false
    end
  end
  
  context "when the target and source use different keys types" do
    it "handles target is string and source is symbol" do
      target = {'a' => 1}
      source = {:a => 1}
      
      WeatherVane::HashComparer.valid?(target, source).should be_true
    end
  
    it "handles target is symbol and source is string" do
      target = {:a => 1}
      source = {'a' => 1}
      
      WeatherVane::HashComparer.valid?(target, source).should be_true
    end
  
    it "handles target is string and source is symbol for multi-levels" do
      target = {'a' => {'b' => 2, 'c' => 3}}
      source = {:a => {'c' => 4}}

      WeatherVane::HashComparer.valid?(target, source).should be_true
    end
    
    it "handles target is symbol and source is string for multi-levels" do
      target = {:a => {'b' => 2, 'c' => 3}}
      source = {'a' => {'c' => 4}}

      WeatherVane::HashComparer.valid?(target, source).should be_true
    end
  end
end