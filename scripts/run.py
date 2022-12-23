
import random
import json
from shapely.geometry import Polygon, Point
import requests


class UserGpsLocation:
    def __init__(self, user_id: int, loc_x: float, loc_y: float):
        self.user_id = user_id
        self.loc_x = loc_x
        self.loc_y = loc_y

    def __str__(self):
        return json.dumps(self.to_json())

    def to_json(self):
        return {'user_id': self.user_id, 'loc_x': self.loc_x, 'loc_y': self.loc_y}


def get_data():
    endpoint = "/get_regions_data"
    response = requests.get(url=endpoint, params={'area_name': 'Malaga'})
    print(response.json())


def main():
    poly = Polygon([
        (43.4167014256239, -7.9987583106850435),
        (43.16079706600621, -1.2970981544350435),
        (38.64656690450792, -0.1984653419350435),
        (36.46953798147447, -5.9113559669350435)])

    points = polygon_random_points(poly, 10)
    endpoint = "/add_point"
    for point in points:
        print(point)
        response = requests.post(url=endpoint, json=point.to_json())
        print(response.json())


def polygon_random_points(poly, num_points):
    min_x, min_y, max_x, max_y = poly.bounds

    points = []
    while len(points) < num_points:
        random_point = Point([random.uniform(min_x, max_x), random.uniform(min_y, max_y)])
        if random_point.within(poly):
            points.append(UserGpsLocation(
                user_id=random.randrange(5),
                loc_x=random_point.x,
                loc_y=random_point.y))
    return points


if __name__ == '__main__':
    #main()
    get_data()
