import random
import json
from shapely.geometry import Polygon, Point
import requests
import sys
import getopt


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


def main(argv):
    arg_url = ""
    arg_points = 1
    arg_help = "{0} --url <url> --points <points_num>".format(argv[0])

    try:
        opts, args = getopt.getopt(argv[1:], "hup:", ["help", "url=", "points="])
    except:
        print(arg_help)
        sys.exit(2)

    print(opts)

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(arg_help)  # print the help message
            sys.exit(2)
        elif opt in ("-u", "--url"):
            arg_url = arg
        elif opt in ("-p", "--points"):
            arg_points = int(arg)

    print('url:', arg_url, 'points:', arg_points)

    # hardcoded area within Spain
    poly = Polygon([
        (43.4167014256239, -7.9987583106850435),
        (43.16079706600621, -1.2970981544350435),
        (38.64656690450792, -0.1984653419350435),
        (36.46953798147447, -5.9113559669350435)])

    points = polygon_random_points(poly, arg_points)
    endpoint = f"{arg_url}/add_point"
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
    main(sys.argv)
    # get_data()
