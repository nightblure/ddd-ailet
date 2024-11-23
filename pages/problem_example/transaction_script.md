# Сравнение подходов к реализации: transaction script

```python {*}{maxHeight:'360px'}
class ProductDbEntity:
    is_active = Column(Boolean)
    product_attributes = relationship("ProductAttributes", foreign_keys="ProductAttributes.product_id")


class ClassDbEntity:
    is_active = Column(Boolean)
    products = relationship("Product", foreign_keys="Product.class_id")


class ProductImportService:
    class_dao: ClassDAO
    db_session_factory: Callable[..., Session]

    def disable_product(self, product_id: str):
        with self.db_session_factory() as db_session:
            class_ = self.class_dao.get_by_product_id(product_id, db_session)

            search_product_generator = (product for product in class_.products if product.id == product_id)
            product = next(search_product_generator, None)

            if product is None:
                raise ProductNotFoundError(product_id)

            if not product.is_active:
                raise ProductAlreadyDisabledError(product_id)

            if class_.is_active:
                raise ProductDisableError(product_id)

            product.is_active = False

            for attribute in product.product_attributes:
                attribute.is_active = False
                attribute.ready_sync = True
                attribute.external_id = None

            active_products_count = sum(1 for product in class_.products if product.is_active)

            if active_products_count == 0:
                class_.is_active = False

            db_session.commit()
            return ...

```
<SlideCurrentNo class="absolute bottom-[5px] left-1/2 transform -translate-x-1/2 items-center" />
