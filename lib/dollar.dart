import 'dart:collection';

import 'package:meta/meta.dart';
// Simplifies the task of implementing hashCode
import 'package:quiver/core.dart';

class Pair {
  String from;
  String to;

  Pair(String from, String to) {
    this.from = from;
    this.to = to;
  }

  bool equals(object) {
    Pair pair = (object) as Pair;
    return from == pair.from && to == pair.to;
  }

  bool operator ==(o) => o is Pair && from == o.from && to == o.to;
  int get hashCode => hash2(from.hashCode, to.hashCode);
}

class Sum implements Expression {
  Expression augend;
  Expression addend;

  Sum(Expression augend, Expression addend) {
    this.augend = augend;
    this.addend = addend;
  }

  Money reduce(Bank bank, String currency) {
    int amount = augend.reduce(bank, currency)._amount +
        addend.reduce(bank, currency)._amount;
    return new Money(amount, currency);
  }

  @override
  Expression plus(Expression addend) {
    return new Sum(this, addend);
  }

  Expression times(int multiplier) {
    return new Sum(augend.times(multiplier), addend.times(multiplier));
  }
}

abstract class Expression {
  Money reduce(Bank bank, String currency);

  Expression plus(Expression addend);

  Expression times(int multiplier);
}

class Bank {
  HashMap rates = new HashMap<Pair, int>();

  Money reduce(Expression source, String currency) {
    return source.reduce(this, currency);
  }

  int rate(String from, String to) {
    if (from == to) return 1;
    return rates[Pair(from, to)];
  }

  void addRate(String from, String to, int rate) {
    rates.putIfAbsent(Pair(from, to), () => rate);
  }
}

class Money implements Expression {
  @protected
  int _amount;

  @protected
  String _currency;

  String currency() {
    return _currency;
  }

  Money(int amount, String currency) {
    this._amount = amount;
    this._currency = currency;
  }

  Money reduce(Bank bank, String currency) {
    int rate = bank.rate(_currency, currency);
    return new Money(_amount ~/ rate, currency);
  }

  Expression times(int multiplier) {
    return new Money(_amount * multiplier, _currency);
  }

  Expression plus(Expression addend) {
    return new Sum(this, addend);
  }

  bool equals(object) {
    return _amount == object._amount && _currency == object.currency();
  }

  static Money dollar(int amount) {
    return new Money(amount, "USD");
  }

  static Money franc(int amount) {
    return new Money(amount, "CHF");
  }

  bool operator ==(o) => o is Money && _amount == o._amount && _currency == o._currency;
  int get hashCode => hash2(_amount.hashCode, _currency.hashCode);
}
