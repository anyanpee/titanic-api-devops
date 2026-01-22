from flask import Blueprint, Response, json

from ..models.person import Person, PersonSchema


people_api = Blueprint("people", __name__)
person_schema = PersonSchema()


@people_api.route("/people", methods=["GET"])
def get_all() -> Response:
    """
    Endpoint returning all people from the database.

    Returns:
        Response containing all people.
    """
    people = Person.get_all()
    data = person_schema.dump(people, many=True)
    return Response(
        json.dumps(data),
        mimetype="application/json",
        status=200,
    )

