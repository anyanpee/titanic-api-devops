from __future__ import annotations
import uuid
from sqlalchemy.dialects.postgresql import UUID
from . import db


class Person(db.Model):
    """
    Database model for storing the data of people on the Titanic.
    """

    __tablename__ = "people"

    uuid = db.Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )

    survived = db.Column(db.Integer)
    passenger_class = db.Column(db.Integer)

    @classmethod
    def get_all(cls):
        return cls.query.all()
