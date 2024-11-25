# Тактические паттерны DDD: объект-значение

```python {*}{maxHeight:'400px'}
@dataclass(frozen=True, slots=True)
class BoundingBox:
    x1: int
    x2: int
    y1: int
    y2: int

    @property
    def x_center(self) -> int:
        return (self.x1 + self.x2) // 2

    @property
    def y_center(self) -> int:
        return (self.y1 + self.y2) // 2

    @property
    def area(self) -> int:
        return (self.x2 - self.x1) * (self.y2 - self.y1)

    def is_intersect_with_other(self, other_bb: 'BoundingBox') -> bool:
        if self.x2 < other_bb.x1 or other_bb.x2 < self.x1:
            return False

        if self.y2 < other_bb.y1 or other_bb.y2 < self.y1:
            return False

        return True

```
<SlideCurrentNo class="absolute bottom-[5px] left-1/2 transform -translate-x-1/2 items-center" />
