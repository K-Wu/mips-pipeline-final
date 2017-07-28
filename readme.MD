# 32bit MIPS PIPELINE
This is a design of 32bit MIPS CPU. It supports a set of core instructions (approx. 30+, with basic integer arithmetic and branch, jump instructions) of 32bit MIPS CPU, and (precise) exception of illegal operation and interuption.

*Please follow the collaboration policy in your course if you are attempting to get advice from this repo. DO NOT COPY.*

## Speed
WNS 9.55ns on Basys3 using Vivado 2014, can perform at highest frequency correctly the assigned task (which is to calculate greatest common divisor, using UART to receive params and send result).

## How we made it?
- How to maintain a correct return address in IRQ handling, considering branch and other complicated situations?
- Why can we achieve such a high speed?   
We provide a detailed report including our design principles, and analysis and solutions of problems in the development.

## What to do next?
1. precise exception with support of overflow, etc.
2. float arithmetic
3. branch prediction
4. deep pipeline

## Some interesting quotes about pipeline from the beloved textbooks
> It is quite a three pipe problem. Sir Arthur Conan Doyle, The Adventures of Sherlock Holmes

> There is less in this than meets the eye. Tallulah Bankhead, remark to Alexander Wollcott, 1922

> If at first you don't succeed, redefine success. Anonymous

# Reference
1. David A. Patterson, John L. Hennessy. Computer Organization and Design, The Hardware/Software Interface, Third Edition[M]. Morgan Kaufmann, 2004.
2. Sarah Harris, David Harris. Digital Design and Computer Architecture: ARM Edition[M]. Morgan Kaufmann, 2015.
3. John L. Hennessy, David A. Patterson. Computer Architecture: A Quantitative Approach[M]. Morgan Kaufmann, 2015.
4. Vivado Design Suite User Guide: Synthesis UG901 (v2017.1)[EB]. April 5, 2017
5. Onur Mutlu. Precise Exception, 15-740/18-740 Computer Architecture[EB].  
<http://www.ece.cmu.edu/~ece740/f11/lib/exe/fetch.php?media=wiki:lectures:onur-740-fall11-lecture8-precise-exceptions-afterlecture.pdf>
6. James F. Frenzel. MIPS Instruction Reference[EB].  
<http://www.mrc.uidaho.edu/mrc/people/jff/digital/MIPSir.html>