from math import radians, cos, sin, asin, sqrt
from region import Region

class LocationCalculator():
    def __init__(self, regions: list[Region], radius_km: int) -> None:
        self.__regions = regions
        self.__radius_km = radius_km

    def find_region_name(self, point_lon: float, point_lat: float) -> str:
        """
        Wrapper around _check_if_in_range. Checks if point is within the region list. 
        If so - return region name
         
        Args:
            point_lon (float) - lontitude of the point
            point_lat (float) - latitude of the point
        Returns:
            The name of the region. Or None if genion not found But this should not be the case.(str)"""
        for region in self.__regions:
             if self._check_if_in_range(region.lon, region.lat, point_lon, point_lat):
                return region.name
        
        return None

    def _check_if_in_range(
        self, area_lon: float, area_lat: float, point_lon: float, point_lat: float) -> bool:
        """
        Checks if point is within the specific area.

        Args:
            area_lon (float) - lontitude of the central area point
            area_lat (float) - latitude of the central area point
            point_lon (float) - lontitude of the point
            point_lat (float) - latitude of the point
        Returns:
            Return if point within the area.(str)"""

        area_lon, area_lat, point_lon, point_lon = map(radians, [area_lon, area_lat, point_lon, point_lon])

        dlon = point_lon - area_lon 
        dlat = point_lat - area_lat 

        a = sin(dlat/2)**2 + cos(area_lat) * cos(point_lat) * sin(dlon/2)**2
        c = 2 * asin(sqrt(a)) 
        calc = c * self.__radius_km

        return calc <= self.__radius_km