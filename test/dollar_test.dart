import 'package:flutter_test/flutter_test.dart';
import 'package:tester/dollar.dart';

void main() => {
      test("Dollar multiplies correctly", () {
        final dollar = Money.dollar(5);
        expect(dollar.times(2), Money.dollar(10));
        expect(dollar.times(3), Money.dollar(15));
      }),
      test("Franc multiplication", () {
        final franc = Money.franc(5);
        expect(franc.times(2), Money.franc(10));
        expect(franc.times(3), Money.franc(15));
      }),
      test("Dollar equals Dollar", () {
        assert(Money.dollar(5).equals(Money.dollar(5)));
      }),
      test("Franc equals Franc", () {
        assert(Money.franc(5).equals(Money.franc(5)));
      }),
      test("Dollar doesn't equal Franc", () {
        assert(!Money.dollar(5).equals(Money.franc(5)));
      }),
      test("test currency types", () {
        expect("USD", Money.dollar(1).currency());
        expect("CHF", Money.franc(1).currency());
      }),
      test("test simple addition", () {
        Money five = Money.dollar(5);
        Expression sum = five.plus(five);
        Bank bank = new Bank();
        Money reduced = bank.reduce(sum, 'USD');
        expect(reduced, Money.dollar(10));
      }),
      test("test plus returns sum", () {
        Money five = Money.dollar(5);
        Expression result = five.plus(five);
        Sum sum = (result) as Sum;
        expect(five, sum.augend);
        expect(five, sum.addend);
      }),
      test("test reduce sum ", () {
        Expression sum = new Sum(Money.dollar(3), Money.dollar(4));
        Bank bank = new Bank();
        Money result = bank.reduce(sum, "USD");
        expect(result, Money.dollar(7));
      }),
      test("test reduce money ", () {
        Bank bank = new Bank();
        Money result = bank.reduce(Money.dollar(1), "USD");
        expect(result, Money.dollar(1));
      }),
      test("test reduce money to different currency ", () {
        Bank bank = new Bank();
        bank.addRate("CHF", "USD", 2);
        Money result = bank.reduce(Money.franc(2), "USD");
        expect(result, Money.dollar(1));
      }),
      test("test identity rate ", () {
        expect(new Bank().rate("USD", "USD"), 1);
      }),
      test("test mixed addition", () {
        Expression fiveBucks = Money.dollar(5);
        Expression tenFrancs = Money.franc(10);
        Bank bank = new Bank();
        bank.addRate("CHF", "USD", 2);
        Money result = bank.reduce(fiveBucks.plus(tenFrancs), "USD");
        expect(result, Money.dollar(10));
      }),
      test("test sum plus money", () {
        Expression fiveBucks = Money.dollar(5);
        Expression tenFrancs = Money.franc(10);
        Bank bank = new Bank();
        bank.addRate("CHF", "USD", 2);
        Expression sum = new Sum(fiveBucks, tenFrancs).plus(fiveBucks);
        Money result = bank.reduce(sum, "USD");
        expect(result, Money.dollar(15));
      }),
      test("test sum times", () {
        Expression fiveBucks = Money.dollar(5);
        Expression tenFrancs = Money.franc(10);
        Bank bank = new Bank();
        bank.addRate("CHF", "USD", 2);
        Expression sum = new Sum(fiveBucks, tenFrancs).times(2);
        Money result = bank.reduce(sum, "USD");
        expect(result, Money.dollar(20));
      }),
    };
