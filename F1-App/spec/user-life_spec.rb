# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require_relative '../app'
require 'rspec'
require 'rack/test'

# Tests para User Model
RSpec.describe User, type: :model do
  let(:user) { User.create(cant_life: 1, last_life_lost_at: 1.minutes.ago) }

  # Tests para regenerar vidas en el momento correcto
  describe '#regenerate_life_if_needed' do
    # Cuando las vidas pueden ser regeneradas
    context 'when lives can be regenerated' do
      # Cuando las vidas se regeneran correctamente, cantidad de vidas < 3
      it 'calculates lives_to_regenerate correctly' do
        allow(Time).to receive(:now).and_return(2.minutes.ago)
        user.regenerate_life_if_needed
        expect(user.cant_life).to eq(2)
      end

      # Cuando las vidas se regeneren que no exceda el maximo (3)
      it 'does not exceed the maximum of 3 lives' do
        user.update(cant_life: 2)
        allow(Time).to receive(:now).and_return(Time.now + 2.minutes) # 2 minutos == 2 vidas nuevas en tiempo
        user.regenerate_life_if_needed
        expect(user.cant_life).to eq(3) # Si las vidas quedan en 3 y no 4 entonces es correcto
      end
    end

    # Cuando las vidas NO pueden ser regeneradas
    context 'when lives cannot be regenerated' do
      # Setea a nil la variable last_life_lost_at si no hay mas vidas para regenerar, asi no hay problemas
      # al perder vidas (por que sino regenera automaticamente)
      it 'resets last_life_lost_at to nil if no lives need regenerating' do
        allow(Time).to receive(:now).and_return(1.minutes.ago)
        user.update(cant_life: 3)
        user.regenerate_life_if_needed
        expect(user.last_life_lost_at).to be_nil
      end
    end
  end

  describe '#can_play?' do
    # Si la cantidad de vidas == 0 no puede jugar
    it 'returns false if cant_life is 0' do
      user.update(cant_life: 0)
      allow(Time).to receive(:now).and_return(10.seconds.ago) # Toma 10 segundos antes por que al inicializarse en 0 le suma 1 vida al instante
      expect(user.can_play?).to be_falsey
    end

    # Si la cantidad de vidas > 0 puede jugar
    it 'returns true if cant_life is greater than 0' do
      user.update(cant_life: 1)
      expect(user.can_play?).to be_truthy
    end
  end
end
