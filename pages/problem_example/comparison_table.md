# Сравнение подходов: выводы

|                                  | Transaction script | Active record | Rich domain model/DDD |
|:---------------------------------|:------------------:|:-------------:|:---------------------:|
| Простота реализации              |        +/-         |       +       |           -           |
| Тестируемость                    |         -          |       +       |          ++           |
| Простота поддержки               |         -          |      +/-      |           +           |
| Высокая связанность (_coupling_) |         +          |       -       |           -           |
| Высокая связность (_cohesion_)   |         -          |       +       |           +           |
| Зависимость от ORM и БД          |         +          |       +       |           -           |

<SlideCurrentNo class="absolute bottom-[5px] left-1/2 transform -translate-x-1/2 items-center" />
