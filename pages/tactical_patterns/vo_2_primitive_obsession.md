# Тактические паттерны DDD: объект-значение, "одержимость примитивами"

<br>

"**Одержимость примитивами**" (_англ_. _**Primitive obsession**_) - 
практика использования «сырых» типов данных для одних и тех же полей в нескольких разных местах.

<br>

```python {*}{maxHeight:'230px'}
class ProductSizeValueObject:
    def __init__(self, value: str | None) -> None:
        self.value = value
        self.validate()

    def validate(self) -> int:
        if self.value in (None, ''):
            self.value = "__"
        
        if isinstance(self.value, str) and len(self.value) > 6: 
            msg = f"'product size' field length must be lower or equal 6 characters" 
            raise ValueObjectError(msg)
    
    @property
    def validated_value(self) -> str:
        return self.value
```

<SlideCurrentNo class="absolute bottom-[5px] left-1/2 transform -translate-x-1/2 items-center" />
