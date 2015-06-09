class Group
	attr_accessor :vertex_list
	attr_accessor :normal_list
	attr_accessor :texture_vertex_list
	attr_accessor :index_list
	attr_accessor :size

	def initialize(group, object)
		triangles = group.triangles
		
		@vertex_list = []
		@texture_vertex_list = []
		@index_list = []
		@normal_list = []

		max_index = calculate_max_index(triangles)
		if object.vertices[max_index].nil?
			diff = -1
		else
			diff = 0
		end
		i = 0

		triangles.each do |triangle|
			load_vertex(object, triangle, i, 0, diff)
			@index_list << i
    		i +=  1
    		load_vertex(object, triangle, i, 1, diff)
			@index_list << i
    		i +=  1
    		load_vertex(object, triangle, i, 2, diff)
			@index_list << i
    		i +=  1
		end
		@size = @index_list.size
		@vertex_list = @vertex_list.pack("f*")
		@index_list = @index_list.pack("I*")
	end

	def draw
		glEnableClientState(GL_VERTEX_ARRAY)
		glEnableClientState(GL_NORMAL_ARRAY) if @normal_list.size > 0
		
		glNormalPointer(GL_FLOAT, 0, @normal_list) if @normal_list.size > 0
		glVertexPointer(3, GL_FLOAT, 0, @vertex_list)

		glDrawElements(GL_TRIANGLES, @size, GL_UNSIGNED_INT, @index_list)

		glDisableClientState(GL_VERTEX_ARRAY)
		glDisableClientState(GL_NORMAL_ARRAY) if @normal_list.size > 0
	end

	private
	def load_vertex(object, triangle, i, vertex, diff)
		index = triangle.vertices[vertex].position_index
		v = object.vertices[index + diff]
		@vertex_list[3 * i] = v.x
		@vertex_list[3 * i + 1] = v.y
		@vertex_list[3 * i + 2] = v.z

		if (object.normals.size > 0)
			index = triangle.vertices[vertex].normal_index
			normal_vertex = object.normals[index + diff]
			normal_list[3 * i] = normal_vertex.x
	    	normal_list[3 * i + 1] = normal_vertex.y
	    	normal_list[3 * i + 2] = normal_vertex.z
	    end
	end

	def calculate_max_index(triangles)
		max_index = 0
		triangles.each do |triangle|
			i = triangle.vertices[0].position_index
			max_index = i if i > max_index
			i = triangle.vertices[1].position_index
			max_index = i if i > max_index
			i = triangle.vertices[2].position_index
			max_index = i if i > max_index
		end
		max_index
	end
end