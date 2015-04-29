RSpec.describe UriMapper do

  let(:o) { described_class }
  let(:ssl) { "https://www.terakeet.com" }
  let(:plain) { "http://cnn.com" }
  let(:pathy) { "http://www.terakeet.com/about/team" }
  let(:pathy_canon_hash) { "4735a7ac7a668b4b22d56f40c6d4a028032ae1b2" }
  let(:fraggy) { "http://www.terakeet.com/thing1/#about" }
  let(:query) { "http://www.terakeet.com/index.php?id=102" }
  let(:long_query) { "http://www.terakeet.com/index.php?id=102&example=yes" }
  let(:fq) { "http://www.terakeet.com/index.php?id=102#thefrag" }
  let(:fraggy_canon_hash) { "c29fa81b36969ed3f09bc5c6226349085d440cf2" }
  let(:invalid_proto) { "ftp://nofrigginway" }
  let(:invalid_all) { "wtf://whoa" }
  let(:what) { o.parse(plain) }
  let(:difficult) { "http://www.bignewsabout.com/asbestos cancer law lawsuit mesothelioma settlement.php" }
  let(:odd) { "http://wwv.rapidprototypingonline.com:8567/Commercial_Service_Providers.htm" }
  let(:make_valid) { [
      ["http:// mommybloghoppers.blogspot.com /", "mommybloghoppers.blogspot.com"],
      ["http:// www.liveandlocalenc.com. /", "liveandlocalenc.com"]
  ]
  }

  it "explodes when the url to parse is missing" do
    expect{o.parse(nil)}.to raise_error ArgumentError
    expect{o.parse("")}.to raise_error ArgumentError
  end

  it "parses the correct domain" do
    expect(o.parse(ssl)[:domain]).to eq("terakeet.com")
    expect(o.parse(ssl)[:www]).to eq(true)
  end
  it "detects ssl" do
    expect(o.parse(ssl)[:ssl]).to eq(true)
  end

  it "keeps the correct proto and simple domain" do
    expect(what[:ssl]).to eq(false)
    expect(what[:domain]).to eq("cnn.com")
    expect(what[:www]).to eq(false)
  end

  describe ".parse" do
    it "finds paths and fragments" do
      expect(o.parse(pathy)[:path]).to eq("/about/team")
      expect(o.parse(query)[:query]).to eq("id=102")
      expect(o.parse(long_query)[:query]).to eq("id=102&example=yes")
      expect(o.parse(fq)[:fragment]).to eq("thefrag")
      expect(o.parse(fq)[:query]).to eq("id=102")
    end

    it "handles odd paths" do
      expect(o.parse(odd)).to eq({domain:    "wwv.rapidprototypingonline.com", port: 8567, ssl: false,
                                  www:       false, path: "/Commercial_Service_Providers.htm",
                                  query:     "", hash: "cbf7d54f1a97dd34c2f8123b2c15c52e5e9e8e54",
                                  canonical: "wwv.rapidprototypingonline.com:8567/Commercial_Service_Providers.htm",
                                  fragment:  "", logical_port: ":8567",
                                  raw: "wwv.rapidprototypingonline.com:8567"
                                 })
    end

    it "handles validating partially futzed domain names" do
      make_valid.each { |ary|
        expect(o.parse(ary[0])[:domain]).to eq(ary[1])
      }
    end

    it "produces canonical paths from full urls" do
      expect(o.parse(pathy)[:canonical]).to eq("terakeet.com/about/team")
      expect(o.parse(fraggy)[:canonical]).to eq("terakeet.com/thing1#about")
      expect(o.parse(query)[:canonical]).to eq("terakeet.com/index.php?id=102")
      expect(o.parse(fq)[:canonical]).to eq("terakeet.com/index.php?id=102#thefrag")
      expect(o.parse(long_query)[:canonical]).to eq("terakeet.com/index.php?id=102&example=yes")
    end

    it "produces canonical paths from domains only" do
      expect(o.parse("terakeet.com")[:canonical]).to eq("terakeet.com/")
    end

    it "errors appropriately" do
      expect { o.parse("SSSFFFPPEW::@#>@#$??@??//") }.to raise_error(ArgumentError, /invalid/i)
    end

    it "produces proper sha1 hashes" do
      expect(o.parse(pathy)[:hash]).to eq(pathy_canon_hash)
    end

    it "doesn't fail on complex URIs" do
      expect { o.parse(difficult) }.to_not raise_error
    end

  end

  describe '.inspect' do
    it 'outputs the proper string' do
      expect(UriMapper.inspect).to eq "UriMapper #{UriMapper::VERSION}"
    end
  end


end