    *Ffile1     cf u e             disk
    * Prototype for procedure FUNCTION
    *D FUNCTION        PR            10I 0
    *D    TERM1                       5I 0 VALUE
    *D    TERM2                       5I 0 VALUE
    *D    TERM3                       5I 0 VALUE

     P Function        B
     D Function        PI            10I 0
     D    Term1                       5I 0 VALUE
     D    Term2                       5I 0 VALUE
     D    Term3                       5I 0 VALUE
     D Result          S             10I 0

         Result = Term1 ** 2 * 17
                      + Term2 * 7
                      + Term3;
         return Result * 45 + 23;

     P                 E


      *comment
comment

      *** constants
     D const1          c                   const(123)
     D const2          c                   const('abc')

      *** standalone fields
      *                         ****** character
     D var1            s              5a

      *                         ****** fixed binary
     D var2            s              9b 0

      *                         ****** date
     D var3            s               d

      *                         ****** 4-byte floating point
     D var4            s              4f

      *                         ****** 8-byte floating point
     D var5            s              8f

      *                         ****** graphic character
     D var6            s             10g

      *                         ****** 3-digit signed integer
     D var7            s              3i 0

      *                         ****** 5-digit signed integer
     D var8            s              5i 0

      *                         ****** 10-digit signed integer
     D var9            s             10i 0

      *                         ****** 20-digit signed integer
     D var10           s             20i 0

      *                         ****** indicator
     D var11           s               n

      *                         ****** packed decimal
     D var12           s              9p 2

      *                         ****** zoned
     D var13           s              9s 2

      *                         ****** time
     D var14           s               t

      *                         ****** 3-byte unsigned integer
     D var15           s              3u 0

      *                         ****** 5-byte unsigned integer
     D var16           s              5u 0

      *                         ****** 10-byte unsigned integer
     D var17           s             10u 0

      *                         ****** 20-byte unsigned integer
     D var18           s             20u 0

      *                         ****** timestamp
     D var19           s               z

      *                         ****** pointer
     D var20           s               *


      *** data structure
     D Partno          DS                  qualified
     D  Manufactr                     4
     D  Drug                          6
     D  Strength                      3
     D  Count                         3  0
