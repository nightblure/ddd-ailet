# DDD и архитектура - доменные события

```python {*}{maxHeight:'400px'}
class DomainEventsMixin:
    _events = collections.deque()

    # Метод для обертки, которая в фоне может здесь забирать сообщения и пушить в шину сообщений
    @classmethod
    def get(cls) -> "BaseEvent | None":
        if len(cls._events) == 0:
            return None
        return cls._events.pop()

    # Метод для использования в доменном слое
    @classmethod
    def push(cls, event: "BaseEvent") -> None:
        cls._events.appendleft(event)


@dataclass(slots=True, frozen=True)
class ChangeProductSizeEvent(BaseEvent):
    product_id: str
    old_value: str
    new_value: str


@dataclass(slots=True)
class ProductEntity(DomainEventsMixin):
    id: str
    size_vo: ProductSizeValueObject
    is_active: bool = True

    def change_size(self, new_value: str | None) -> None:
        old_value = self.size_vo.validated_value
        self.size_vo.set_value(new_value).validated_value

        event = ChangeProductSizeEvent(
            product_id=self.id,
            old_value=old_value,
            new_value=self.size_vo.validated_value
        )
        
        self.push(event)
        return None

```
<SlideCurrentNo class="absolute bottom-[5px] left-1/2 transform -translate-x-1/2 items-center" />
