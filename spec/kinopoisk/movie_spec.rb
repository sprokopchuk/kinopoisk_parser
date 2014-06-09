#coding: UTF-8
require 'spec_helper'

describe Kinopoisk::Movie, vcr: { cassette_name: 'movies' } do
  let(:dexter) { Kinopoisk::Movie.new 277537 }
  let(:avatar) { Kinopoisk::Movie.new 251733 }

  it { dexter.url.should eq('http://www.kinopoisk.ru/film/277537/') }
  it { dexter.title.should eq('Правосудие Декстера') }
  it { dexter.title_en.should eq('Dexter') }

  it { dexter.poster.should eq('http://st.kp.yandex.net/images/film_iphone/iphone360_277537.jpg') }
  it { dexter.poster_big.should eq('http://st.kp.yandex.net/images/film_big/277537.jpg') }

  it { dexter.year.should eq(2006) }
  it { dexter.countries.should eq(['США']) }
  it { dexter.slogan.should eq('«Takes life. Seriously»') }
  it { dexter.directors.should eq(['Джон Дал','Стив Шилл','Кит Гордон']) }
  it { dexter.writers.should eq(['Скотт Бак', 'Карен Кэмпбелл', 'Дэниэл Церон']) }
  it { dexter.producers.should eq(['Сара Коллетон','Джон Голдвин','Роберт Ллойд Льюис']) }
  it { dexter.operators.should eq(['Ромео Тироне','Джеф Джёр','Мартин Дж. Лэйтон']) }
  it { dexter.composers.should eq(['Дэниэл Лихт']) }
  it { dexter.art_directors.should eq(['Джессика Кендер','Энтони Коули','Эрик Уейлер']) }
  it { dexter.editors.should eq(['Луис Ф. Циоффи','Стюарт Шилл','Кит Хендерсон']) }
  it { dexter.genres.should eq(['триллер','драма','криминал', 'детектив']) }
  it { dexter.actors.should include('Майкл С. Холл', 'Дженнифер Карпентер') }
  it { dexter.description.should match('Декстер Морган.') }
  it { dexter.premiere_world.should eq('1 октября 2006') }
  it { dexter.premiere_ru.should eq('3 ноября 2008') }
  it { dexter.minimal_age.should eq('зрителям, достигшим 18 лет') }
  it { dexter.duration.should eq ('55 мин.') }
  it { dexter.imdb_rating_count.should be_a(Integer) }
  it { dexter.imdb_rating.should be_a(Float) }
  it { dexter.rating_count.should be_a(Integer) }
  it { dexter.rating.should be_a(Float) }
  it { dexter.box_office_ru.should eq('') }
  it { avatar.box_office_world.should match('[$\d]') }
  it { avatar.box_office_ru.should match('[$\d]') }
  it { avatar.box_office_us.should match('[$\d]') }
  it { avatar.budget.should eq('$237 000 000') }
  it { avatar.length.should eq(162) }

  it 'should make only one request' do
    dexter.title
    dexter.countries
    a_request(:get, dexter.url).should have_been_made.once
  end

  it 'should raise error if nothing found' do
    expect { Kinopoisk::Movie.new(111111111).title }.to raise_error
  end

  context 'by title' do
    let(:dexter_by_title) { Kinopoisk::Movie.new 'Dexter' }

    it { dexter.url.should eq(dexter_by_title.url) }

    it 'should make only one request to initialize' do
      dexter_by_title
      a_request(:get, /.*/).should have_been_made.once
    end

    it 'should make max two requests' do
      dexter_by_title.title
      dexter_by_title.countries
      a_request(:get, /.*/).should have_been_made.twice
    end
  end
end
